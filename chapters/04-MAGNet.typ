#import "@preview/modern-ecnu-thesis:0.3.0": documentclass, indent, no-indent, word-count-cjk, total-words, bilingual-figure


= 融合多模态语义提示的一体化GISR方法

== 引言

在前一章中，为了解决一体化GISR任务中存在的负迁移问题，本文尝试了一种基于纯视觉感知的解决方案——VP-Net。该方法创新性地引入了动态路由机制，利用引导图像的纹理、边缘等底层视觉特征作为隐式信号，将不同模态的数据分流至不同的专家网络进行处理。实验结果证实，这种基于视觉特征的物理隔离策略在一定程度上缓解了多任务间的优化冲突，优于传统的静态参数共享模型。

然而，VP-Net 本质上是一个仅依赖数据驱动的视觉主导版本，可视作本章所提完整方法的一个退化特例。它虽然能够“看见”图像纹理的差异，却无法真正理解任务的语义本质。在处理复杂多变的GISR任务时，这种仅依赖底层视觉特征的路由机制暴露出了两个关键局限：

首先是视觉歧义性。不同任务的图像在局部可能表现出极为相似的纹理统计特性。例如，平滑的深度图区域与磁共振影像的背景区域在梯度分布上可能难以区分，单纯依靠视觉感知的路由模块极易产生混淆，导致无法精确激活最优的专家组合。

其次是语义缺失。GISR 任务通常包含明确的先验定义，如数据源的传感器类型、具体的任务目标以及缩放倍率（$4 times$ vs $8 times$）。这些高层语义信息对于指导模型进行针对性的重建至关重要，但在 VP-Net 中，这些关键的上下文信息被隐式包含或者完全忽略了。

为了显式地充分利用这些高层语义信息，本章在 VP-Net 的架构基础上，提出了一种融合多模态语义提示的一体化 GISR 方法（Multi-modal All-in-one Guided Network, MAG-Net）。

MAG-Net 的核心思想在于引入文本语义先验来修正并增强动态路由的决策过程。为此，本文设计了一个多模态提示生成模块（Multi-modal Prompt Generation Module, MPGM）。该模块利用预训练的大规模视觉-语言模型：CLIP~@radford2021learning 作为文本编码器，将任务的具体描述（如“Image pair for 4$times$ depth image super-resolution task”）转化为富含语义的高维特征向量注入到动态路由网络中。

通过这种视觉感知 + 语义引导的双重驱动机制，MAG-Net 能够在像素级和任务级同时对特征进行精细化调控。高层语义提示为路由模块提供了全局的任务上下文，消除了视觉特征的歧义性，确保任务被正确分类；而底层视觉感知则保留了对局部空间纹理的自适应能力。两者相辅相成，使得模型不仅实现了任务间的彻底解耦，更能够利用不同任务间的语义关联促进知识的正向迁移。本章将详细阐述 MAG-Net 的网络架构与提示学习机制，并通过对比实验证明，在引入语义交互后，模型在全色锐化、深度图超分及磁共振超分三个子任务上均取得了显著优于 VP-Net 及现有专用模型的性能表现。



== 算法概述

本章这一部分将详细阐述 MAG-Net 的实施细节。针对多模态一体化任务中纯视觉感知存在的“歧义性”与“语义缺失”问题，MAG-Net 在 VP-Net 的架构基础上进行了语义增强。其核心在于引入了任务描述文本作为显式的先验信息，并通过设计专门的模块将语义特征注入到动态路由的决策过程中，从而实现视觉+语义双重驱动的任务解耦。

=== 整体网络架构

#figure(
  caption: [MAG-Net 网络整体架构示意图],
)[
#image("../images/04/model_4.png", width: 100%)
] <MAGNet-Ach>

如@fig:MAGNet-Ach 所示，MAG-Net 建立在一个分层的 U 型编码器-解码器骨干网络之上，整体流程包含三个关键阶段：多模态输入编码、基于语义增强的动态特征映射、以及高分辨率图像重建。
   
模型的输入由三部分组成：待恢复的低分辨率目标图像 $I_"LR" in RR^(H times W times C_"in")$、同场景的高分辨率引导图像 $I_"HR" in RR^("sH" times "sW" times C_"guide")$（$s$ 为超分倍率），以及描述当前任务属性的自然语言文本 $T$。
针对图像数据，本文利用两个独立的 $3 times 3$ 卷积层分别将 $I_"LR"$ 和 $I_"HR"$ 映射到统一的特征通道维度 $C$，得到浅层特征 $F_"LR"^0$ 和 $F_"HR"^0$。其中 $F_"LR"^0$ 作为主干网络的输入流，$F_"HR"^0$ 则作为视觉引导信号被送入后续的路由模块。
针对文本数据 $T$，本文设计了**多模态提示生成模块MPGM**。该模块利用CLIP作为文本语义编码器，将离散的文本指令转化为连续的高维语义提示向量 $P_"sem"$。这个语义向量承载了任务的全局定义，充当了后续动态路由过程中的语义锚点。

编码器包含 4 个层级，旨在逐步提取深层抽象特征。每个层级堆叠了若干 Transformer Block，用于捕捉图像的局部细节与长距离依赖。与 VP-Net 仅依赖视觉特征进行路由不同，MAG-Net 在编码器的每个层级嵌入了**多模态引导路由模块（Multi-modal Guided Routing Module, MGRM）**。
在第 $l$ 个层级，MGRM 同时接收三组输入信号：当前主干特征 $F_l^"enc"$、下采样的视觉引导特征 $F_"guide"^l$ 以及全局语义提示 $P_"sem"$。MGRM 作为一个智能的“调度中心”，通过交叉注意力或特征拼接的方式，融合底层的视觉纹理信息与高层的语义任务指令，生成像素级的门控权重。这些权重动态地激活特定的专家网络组合，从而对特征进行针对性的处理。
通过引入 $P_"sem"$，MGRM 能够有效消除仅靠视觉特征难以区分的歧义，确保特征被路由至语义上正确的专家路径，实现了比 VP-Net 更彻底的任务解耦。
层级间的下采样操作采用 Pixel-Unshuffle，以在降低分辨率的同时保留完整的通道信息。

**解码器与图像重建**
解码器结构与 VP-Net 保持一致，包含 4 个对称的层级。由于编码阶段的 MGRM 已经完成了基于语义的任务解耦与特征增强，解码阶段主要负责利用这些纯净的特征恢复空间细节。因此，解码器采用标准的共享参数 Transformer Block，未引入额外的路由机制。
解码器通过跳跃连接（Skip Connections）融合编码器传递的多尺度特征，并通过 Pixel-Shuffle 操作逐步恢复图像的空间分辨率。最终，网络输出残差图像 $I_"res"$，并与经双线性插值上采样的输入 $I_"LR"$ 相加，得到最终的超分辨率结果 $I_"SR"$：
$ I_"SR" = I_"res" + "Upsample"(I_"LR") . $

综上所述，MAG-Net 通过在骨干网络中无缝集成文本语义先验，将视觉感知和高级语义信息相结合，构建了一个具备认知能力的一体化图像修复框架。

=== 多模态提示生成模块 <MPGM_Section>

为了向网络提供精确且对任务敏感的语义引导，需要将离散的自然语言描述转化为能够与视觉特征进行交互的连续嵌入向量。然而，直接使用预训练语言模型（如 BERT 或 CLIP）输出的特征往往存在两个问题：一是领域偏差，通用大模型对特定遥感或医学术语的理解可能不够细粒度；二是模态隔离，纯文本特征无法感知当前输入图像的具体状态（如噪声水平或纹理复杂度）。为此，本文设计了多模态提示生成模块（MPGM），引入了字典学习（Dictionary Learning）的思想。

MPGM 的处理流程如@fig:MPGM 所示，包含视觉-文本特征提取、跨模态特征调制以及基于字典的提示重构三个阶段。

#figure(
  caption: [多模态提示生成模块示意图],
)[
#image("../images/04/MPGM.png", width: 95%)
] <MPGM>

#heading(level: 4, numbering: none)[视觉-语言特征提取]
首先，对于描述任务属性的文本指令 $T$，本文利用预训练的 CLIP 文本编码器提取其高维语义特征 $F_"text" in RR^(D_t)$。
与此同时，为了确保生成的提示能适应当前的图像内容，本文提取图像的视觉上下文。通过两个轻量级的卷积网络 $cal(E)_"LR"$ 和 $cal(E)_"HR"$ 分别提取低分辨率模型输入 $I_"LR"$ 和高分辨率引导图 $I_"HR"$ 的浅层特征，并通过通道拼接与 $1 times 1$ 卷积融合操作获得联合视觉特征 $F_"vis" in RR^(C times H times W)$：
$ F_"vis" = cal(F)_"fuse"("Concat"(cal(E)_"LR"(I_"LR"), cal(E)_"HR"(I_"HR"))),  $
#{
set par(first-line-indent: 0pt)
[这使得模块在处理不同图像时能够具有自适应的感知能力。
]
}
#heading(level: 4, numbering: none)[跨模态特征调制]

为了将显式的语义指令注入到底层的视觉特征中，本文采用特征线性调制（FiLM）机制。具体而言，利用两个全连接层从文本特征 $F_"text"$ 中预测出缩放系数 $gamma$ 和平移系数 $beta$，对视觉特征 $F_"vis"$ 进行通道级的仿射变换：
$ F_"mix" = (1 + gamma(F_"text")) dot.circle F_"vis" + beta(F_"text") , $
#{
set par(first-line-indent: 0pt)
[其中，$dot.circle$ 表示逐元素乘法，公式中的 $1$ 代表残差连接，保证了视觉信息的完整传递。经过这一步，生成的 $F_"mix"$ 既包含了图像的空间纹理信息，也被赋予了明确的任务语义倾向。
]
}

#heading(level: 4, numbering: none)[基于字典的提示重构]
为了获得更加紧凑且适用于 GISR 任务的提示表示，本文不再直接使用混合特征，而是将其作为一个查询信号，去检索一组可学习的语义锚点。本文预定义了一个任务无关的共享提示字典 $cal(D) = {bold(d)_1, bold(d)_2, dots, bold(d)_K}$，其中 $bold(d)_k in RR^D$ 为第 $k$ 个潜在的语义原子，$K$ 为原子总数。
本文将 $F_"mix"$ 进行全局平均池化得到向量 $bold(z)$，并通过一个线性分类器预测其在字典上的注意力分布（即当前样本属于哪种潜在任务模式的概率）：
$ bold(w) = "Softmax"(bold(W)_p bold(z)) in RR^K . $
最终的语义提示 $P_"sem"$ 由字典原子加权组合而成：
$ P_"sem" = sum_(k=1)^K w_k bold(d)_k . $
这种设计即是一种软聚类过程，模型自动学习从复杂的视觉-文本混合空间到一组纯净的任务基向量的映射。由此生成的 $P_"sem"$ 既具有文本赋予的语义指向性，又经过了图像内容的校准，为后续的动态路由提供了鲁棒的先验信号。

=== 融合多模态提示的动态路由模块 <MAGNet-MGRM>

在第三章中，本文提出了视觉感知路由模块，通过感知引导图像的纹理和边缘信息来实现任务特征的物理解耦。然而，正如引言所述，仅依靠视觉特征容易产生歧义。为了解决这一问题，本文将多模态提示生成模块生成的语义提示 $P_"sem"$ 引入到路由决策中，设计了融合多模态提示的动态路由模块（Multi-modal Guided Routing Module, MGRM）。

如@fig:MGRM 所示，MGRM 在架构上继承了 VPRM 的稀疏门控混合专家设计，保留了混合专家组和稀疏分发与聚合机制。其核心改进在于**门控网络的输入特征构造**，从单纯的视觉感知升级为视觉-语义联合感知。

#figure(
  caption: [融合多模态提示的动态路由模块示意图],
)[
#image("../images/04/MGRM.png", width: 95%)
] <MGRM>


在编码器的第 $l$ 层级，MGRM 接收三路输入：主干特征 $F_l$、引导特征 $F_"guide"$ 以及语义提示向量 $P_"sem"$。与 VPRM 仅拼接 $F_l$ 和 $F_"guide"$ 不同，MGRM 采用了一种级联融合策略来生成门控信号：

首先，主干特征与引导特征在通道维度拼接，并经过一个 $1 times 1$ 卷积层进行初步融合，得到视觉上下文特征 $F_"vis"'$：
$ F_"vis"' = "Conv"_1 (["Concat"(F_l, F_"guide")]) . $

随后，为了将全局语义信息注入到局部门控决策中，本文将语义提示向量 $P_"sem"$ 在空间维度上进行广播，使其尺寸扩充为与 $F_"vis"'$ 一致，即 $P_"sem" in RR^(B times C times H times W)$。扩充后的语义提示与视觉上下文特征再次拼接，并通过第二层卷积进行深度融合：
$ F_"gate" = "Conv"_2 (["Concat"(F_"vis"', P_"sem")]) . $

通过引入 $P_"sem"$，门控网络不仅能感知像素局部的纹理差异（由 $F_"guide"$ 提供），还能明确知晓当前任务的全局定义（由 $P_"sem"$ 提供）。例如，在处理深度图超分任务时，即便某些区域的纹理与 MRI 图像相似，由于 $P_"sem"$ 中包含了明确的“Depth Image”的语义编码，门控网络依然能够抑制磁共振超分相关专家的激活，强制将特征路由至负责深度图超分的专家。

最后，融合后的特征 $F_"gate"$ 经过激活函数调制，并与其自身产生的注意力图相乘（类似 GLU 门控线性单元结构），生成最终用于预测路由分数的像素级特征向量 $bold(f)_"gate"$：
$ bold(f)_"gate" = "Conv"_3 ("GELU"(F_"gate") dot.circle F_"vis"') . $

基于该特征，本文沿用第三章所述的**带噪声 Top-K 门控机制**，计算每个像素分配给各个专家的权重，并进行稀疏分发：
$ G(bold(f)_"gate") = "Softmax"("TopK"(bold(f)_"gate" W_g + "Noise")) . $

通过这种设计，MGRM 实际上构建了一个条件概率模型 $P("Expert" | "Visual", "Semantic")$。相较于 VP-Net 的 $P("Expert" | "Visual")$，MGRM 在决策时引入了额外的语义条件变量，大大降低了路由选择的不确定性，实现了更精准、更鲁棒的一体化任务解耦。

== 实验设置

为了公平评估 MAG-Net 在一体化 GISR 任务中的性能，本章的实验设置与第三章保持一致：将 MAG-Net 在全色锐化、深度图超分以及磁共振图像超分三个任务上进行了统一的训练与评估。

=== 数据集与评测指标
本章沿用了第三章所述的三个标准数据集：(1) **全色锐化**使用 QuickBird、WorldView-4 和 GaoFen-1 卫星数据集~@pansharpening_dataset_meng2020large，评估指标包括 PSNR、SAM 和 ERGAS；(2) **深度图超分**采用 NYU v2 RGB-D 数据集~@depth_dataset_silberman2012indoor，主要评估指标为 RMSE；(3) **磁共振图像超分**基于 BrainTS 数据集，使用 PSNR 和 SSIM 进行评价。所有数据集的预处理方式、划分比例以及实验的超分倍率（全色锐化 4×，深度图 4×/8×/16×，MRI 2×/4×/8×）均与前章一致。

=== 实验细节
MAG-Net 基于 PyTorch 框架实现，并在单块 NVIDIA RTX 3090 GPU 上进行训练。训练策略包括优化器选择、初始学习率及其衰减策略、批次大小以及总训练轮次，均与 VP-Net 的实验配置保持一致。在一体化联合训练过程中，本文同样采用了基于最小数据集长度对齐的策略，并混合所有任务的数据进行随机采样，以确保模型能够均衡地学习多种任务特性。与 VP-Net 唯一的区别在于，MAG-Net 在输入端额外接收了任务描述文本，并利用预训练的 CLIP 模型提取语义特征。

== 实验结果

=== 对比实验

//***********  all-in-one  ***********
#heading(level: 4, numbering: none)[一体化方法对比]

本文将 MAG-Net 与目前领先的一体化图像复原方法进行了比较，包括 AirNet~@allinone_li2022all、TransWeather~@compare_allinone_valanarasu2022transweather、PromptIR~@potlapalli2023promptir、GridFormer~@compare_allinone_wang2024gridformer、CAPTNet~@gao2024prompt 和 AdaIR~@cui2025adair。这些方法大多基于通用的 Encoder-Decoder 架构或 Transformer 结构，旨在通过单一网络权重处理多种退化类型（如去雨、去噪、去雾）。

为了将这些主要针对 RGB 图像（3 通道）设计的通用模型适配到 GISR 任务中，必须解决输入维度不一致的问题。GISR 的三个子任务具有完全不同的输入数据结构：磁共振超分输入为 2 通道（单通道的引导图和单通道的目标图），深度图超分为 4 通道（3通道的引导图和单通道的目标图），而全色锐化则为 5 通道（单通道的引导图和4通道的目标图）。直接将这些数据输入到期望 3 通道输入的预训练模型中是不可行的。为此，本文在所有对比实验中均采用了与 VP-Net/MAG-Net 相同的多头输入适配策略：为每个任务的特定通道数单独实例化一个浅层映射层，将不同维度的原始输入统一映射到该模型的标准特征维度。这种做法确保了对比的公平性——所有模型都获得了完全相同的信息量，且核心处理逻辑保持原样。

实验结果如@tbl:MAGNet_all-in-one_pansharpening、@tbl:MAGNet_all-in-one_mri 和 @tbl:MAGNet_all-in-one_depth 所示。在所有三个任务中，MAG-Net 均显著优于所有竞争对手。值得注意的是，PromptIR 虽然引入了视觉提示机制来处理不同任务，但由于缺乏显式的多模态语义指引，其未能充分利用 GISR 任务中丰富的先验知识（如光谱特性或模态类型）。相比之下，MAG-Net 通过引入语义提示 $P_"sem"$，在特征空间中构建了更明确的任务边界，使得模型能够更精准地调用专家网络，从而在处理复杂的异构任务时表现出更优越的性能。特别是与上一章的 VP-Net 相比，引入语义增强后的 MAG-Net 在任务区分度较低的场景（深度图平滑区域与磁共振图像背景）中取得了更大的性能增益，进一步验证了视觉+语义双重驱动的有效性。


// all-in-one: pansharpening
#include "../tables/04/all-in-one/Pansharpening.typ"

#figure(
  caption: [一体化设置下全色锐化任务的可视化对比与误差图],
)[
#image("../images/04/compare_pan.png", width: 105%)
] <compare_all-in-one_pansharpening>


// all-in-one: MRI
#include "../tables/04/all-in-one/MRI.typ"
#figure(
  caption: [一体化设置下磁共振图像超分任务的可视化对比与误差图],
)[
#image("../images/04/compare_mri.png", width: 105%)
] <compare_all-in-one_mri>

// all-in-one: Depth
#include "../tables/04/all-in-one/Depth.typ"
#figure(
  caption: [一体化设置下深度图超分任务的可视化对比与误差图],
)[
#image("../images/04/compare_depth.png", width: 105%)
] <compare_all-in-one_depth>



//***********  one-by-one  ***********
#heading(level: 4, numbering: none)[单任务方法对比]

为了验证 MAG-Net 在特定领域是否也能达到甚至超越专用模型的水平，本文将 MAG-Net 分别与全色锐化、磁共振超分和深度图超分领域的先进单任务模型（SOTA）进行了对比。

**全色锐化任务：**
如@tbl:MAGNet_one-by-one_pansharpening 所示，本文将 MAG-Net 与包括 AWFLN~@compare_pan_lu2023awfln、DISPNet~@compare_pan_jia2018dispnet、LAGConv~@compare_pan_jin2022lagconv、M3DNet~@compare_pan_li2020m3dnet、FusionMamba~@peng2024fusionmamba 和 Dif-Pan~@compare_pan_cao2024diffusion 在内的经典及最新深度学习方法进行了比较。尽管这些方法是专门为全色锐化任务设计并针对特定光谱特性进行了优化的，MAG-Net 依然在所有三个数据集（WorldView-4, QuickBird, GaoFen-1）上取得了具有竞争力的表现。具体而言，MAG-Net 在保持光谱保真度（SAM）和空间细节恢复（ERGAS）方面表现优异，这得益于其强大的 Transformer 骨干网络以及通过语义提示明确激活的锐化感知专家模块。@fig:compare_one-by-one_pansharpening 的可视化结果进一步显示，MAG-Net 生成的图像在边缘清晰度和光谱一致性上均优于许多现有方法，有效避免了常见的光谱扭曲现象。

// one-by-one: pansharpening
#include "../tables/04/one-by-one/Pansharpening.typ"
#figure(
  caption: [单任务设置下全色锐化任务的可视化对比与误差图],
)[
#image("../images/04/compare_single_pan.png", width: 100%)
] <compare_one-by-one_pansharpening>


**磁共振图像超分任务：**
在医学图像领域，本文将 MAG-Net 与 MGDUN~@compare_mri_yang2023mgdun、DuDoNet~@lei2023deep、MINet~@compare_mri_pang2020multi、MASA~@compare_mri_lu2021masa、McMRSR~@compare_mri_li2022transformer 和 SANet~@feng2024exploring 等专用模型进行了对比。@tbl:MAGNet_one-by-one_mri 展示了定量评估结果。MAG-Net 在 PSNR 和 SSIM 指标上持续领先，特别是在高倍率（$4 times$ 和 $8 times$）下优势更为明显。医学图像通常具有复杂的解剖结构且对细节丢失极为敏感，MAG-Net 通过语义提示准确识别出 MRI 任务特征，并动态调用能够捕捉精细纹理的专家网络，从而实现了更高质量的解剖结构重建。@fig:compare_one-by-one_mri 的误差图显示，MAG-Net 的重建结果与 Ground Truth 之间的残差最小，有效抑制了伪影的产生。

// one-by-one: mri
#include "../tables/04/one-by-one/MRI.typ"
#figure(
  caption: [单任务设置下磁共振图像超分任务的可视化对比与误差图],
)[
#image("../images/04/compare_single_mri.png", width: 105%)
] <compare_one-by-one_mri>

**深度图超分任务：**
针对深度图超分，本文选取了 GeoDSR~@compare_depth_geodsr、DAGF~@zhong2023deep、AHMF~@compare_depth_ahmf:zhong2021high、DCTNet~@compare_depth_dctnet:zhao2022discrete、DKN~@depth_kim2021deformable 和 SGNet~@wang2024sgnet 作为对比基准。由于深度图具有分段平滑的特性，且边缘信息的保持至关重要。如@tbl:MAGNet_one-by-one_depth 所示，MAG-Net 在 RMSE 指标上取得了最低的误差，表明其恢复的深度值最接近真实值。这主要归功于 MAG-Net 的多模态引导机制，它不仅利用了高分辨率 RGB 图像作为结构引导，还通过语义提示强化了模型对深度图几何特性的理解，使其能够更好地区分边缘与平滑区域。@fig:compare_one-by-one_depth 的可视化结果表明，MAG-Net 生成的深度图边缘锐利且内部平滑，显著减少了以往方法中常见的模糊和锯齿效应。

// one-by-one: depth
#include "../tables/04/one-by-one/Depth.typ"
#figure(
  caption: [单任务设置下深度图超分任务的可视化对比与误差图],
)[
#image("../images/04/compare_single_depth.png", width: 105%)
] <compare_one-by-one_depth>


综上所述，MAG-Net 不仅是一个通用的一体化框架，其在各个子任务上的表现也接近甚至超越各领域的专用 SOTA 模型。这证明了通过引入多模态语义提示，通用的骨干网络完全有能力学习到高度专业化的任务表征，同时具有通用性和专业性。

=== 消融实验

为了验证 MAG-Net 中各个核心组件的有效性以及不同设计选择对模型性能的影响，本文进行了详细的消融实验。

#heading(level: 4, numbering: none)[MPGM与MGRM的有效性]
为了探究多模态提示生成模块MPGM和多模态引导路由模块MGRM对模型性能的贡献，本文设计了以下几种变体进行对比，实验结果如@tbl:ablation_modules 所示，需要解释的是：
1.  w/o MPGM & w/o MGRM: 移除 MPGM 和 MGRM，退化为通过简单的参数共享处理所有任务的静态 Backbone 网络。
2.  w/ MPGM & w/o MGRM: 仅保留 MPGM 生成语义提示，将其直接注入到网络中，但不使用动态路由机制即所有任务仍共享同一套参数。
3.  w/o MGRM & w/ MGRM：仅保留 MGRM 的动态路由结构，但不引入语义提示 $P_"sem"$，仅依赖视觉特征 $F_"guide"$ 进行路由决策。需要强调的是，这一配置（@tbl:ablation_modules 中的第三行）等同于本文在第三章中提出的 VP-Net。
4. w/ MPGM & w/MGRM： 同时包含 MPGM 和 MGRM，利用语义增强的动态路由进行任务解耦即MAG-Net。

#include "../tables/04/ablation/module.typ"

从@tbl:ablation_modules 可以观察到：
- 与静态的 Baseline 相比，引入动态路由机制（VP-Net，第三行）在所有任务上均带来了性能提升，证明了任务解耦的必要性。
- 然而，仅依赖视觉引导的 VP-Net 在某些复杂场景下的提升有限。相比之下，引入 MPGM（第二行）虽然没有使用路由，但通过语义提示给予了网络一定的任务先验，性能优于 Baseline。
- 完整的 MAG-Net（第四行）取得了最佳性能。与第三行（VP-Net）的直观对比尤为关键：在引入 MPGM 将语义信息注入路由过程后，模型在全色锐化、MRI SR 和 Depth SR 任务上分别获得了进一步的性能增益（例如在 MRI 任务上 PSNR 提升了约 0.25 dB）。这有力地证明了 VP-Net 存在的视觉歧义性问题得到了有效缓解，显式的语义提示 $P_"sem"$ 成功指导了门控网络做出更准确的决策，激活了更适配的专家路径，从而突破了纯视觉感知的性能瓶颈。


#heading(level: 4, numbering: none)[任务组合消融]
为了探究多任务联合训练带来的收益（即正向迁移）以及任务间的相互影响，本文在@tbl:ablation_task_combination 中比较了单任务训练与不同任务组合的联合训练性能。

#include "../tables/04/ablation/task_combination.typ"

实验结果表明，任务间的联合训练*并非*总是带来正向收益：
- **单任务训练 (Single-Task)**: 作为基准，模型专注于单一分布的数据。
- **两两组合训练 (Task Pairs)**: 本文发现某些任务组合（如 Depth + MRI）由于模态差异巨大且缺乏语义桥梁，在没有良好解耦的情况下甚至会出现严重的负迁移（性能低于单任务模式）。
- 一体化训练: 得益于 MAG-Net 强大的语义解耦能力，在联合所有三个任务进行训练时，模型不仅未受负迁移影响，反而在所有任务上都超越了单任务基准。这说明 MAG-Net 成功利用了不同任务间的高层语义关联（如结构一致性），实现了“互助互利”的正向知识迁移。


#heading(level: 4, numbering: none)[多模态提示消融]
为了验证 MPGM 中视觉+文本多模态提示设计的合理性，本文对比了仅使用文本提示、仅使用图像提示即视觉特征以及两者结合的情况。

#include "../tables/04/ablation/prompt.typ"

结果如@tbl:ablation_prompt 所示：
- **Text Only**: 仅利用 CLIP 提取的文本特征能提供较好的全局任务区分度，但在处理图像特有的退化（如不同程度的噪声）时适应性较差。
- **Image Only**: 仅利用图像特征能感知局部纹理，但缺乏明确的任务目标指引，容易在纹理相似的任务间产生混淆。
- **Text + Image (MAG-Net)**: 融合两者生成的 Prompt 既具备明确的语义指向性，又拥有对输入内容的自适应感知能力，因此取得了最优的性能表现。这一结果验证了本文在 MPGM 中引入跨模态特征调制（FiLM）及字典重构机制的有效性。

=== 任务提示的可视化 <vis_prompt>

为了直观地验证 MAG-Net 中生成的任务提示是否真正捕捉到了不同 GISR 任务的语义特征，本文提取了MPGM输出的高维提示向量 $P_"sem"$，并利用 t-SNE 技术将其投影到二维平面进行可视化分析。这一可视化实验旨在回答两个核心问题：
- 第一，对于不同GISR任务，生成的提示是否具有显著的区分度？
- 第二，对于同一任务下的不同细粒度属性（如不同的超分倍率），提示能否体现出相应的差异性？

@fig:tSNE-1 展示了 MAG-Net 在3个GISR任务生成的提示分布情况。从图中可以清晰地观察到，属于同一大类任务的提示向量紧密聚集在一起，而不同任务类别的提示簇之间呈现出显著的分离态势。具体而言，Pansharpening（蓝色系）、Depth SR（红色系）和 MRI SR（绿色系）三个任务的提示分别占据了特征空间的不同区域，且边界清晰。这一结果有力地证明了 MPGM 成功地将自然语言描述中的离散语义映射为了连续且具有判别力的特征表示，使得模型能够明确区分具有不同物理属性和恢复目标的任务，从而为后续 MGRM 中的精确路由提供了可靠的证据。这种基于语义的任务解耦能力，正是 MAG-Net 能够克服 VP-Net 视觉歧义性问题的关键所在。

#figure(
  caption: [MAG-Net 在所有数据集的所有 GISR 子任务上的提示表示 t-SNE 可视化],
)[
#image("../images/04/tSNE1.png", width: 70%)
] <tSNE-1>

进一步地，为了探究提示对细粒度任务属性的敏感性，本文在@fig:tSNE-2 中专门展示了 MRI 图像超分任务在不同缩放倍率（$2 times$、$4 times$、$8 times$）下的提示分布。可视化结果显示，即便是在同一任务模态内部，对应于不同缩放因子的提示也呈现出了有序的聚类结构。$2 times$、$4 times$ 和 $8 times$ 的提示分别形成了独立的条带状子簇，这表明 MAG-Net 生成的提示不仅编码了高层的任务类别信息（Task Type），还敏锐地捕捉到了底层的操作参数（。这种细粒度的语义感知能力使得模型能够根据具体的退化程度动态调整专家的激活模式，从而在统一框架下实现对多尺度任务的精细化处理。

综上所述，t-SNE 可视化实验从特征流形空间的角度证实了 MPGM 的有效性：生成的提示向量既具有类间可分性，又具备类内紧凑性。




#figure(
  caption: [MAG-Net 在磁共振图像超分任务中不同超分比率下的提示表示 t-SNE 可视化],
)[
#image("../images/04/tSNE2.png", width: 70%)
] <tSNE-2>












== 本章小结

本章针对上一章 VP-Net 模型中存在的视觉歧义性与语义缺失问题，提出了一种融合多模态语义提示的一体化引导式图像超分方法（MAG-Net）。该方法在继承视觉感知动态路由架构的基础上，引入了文本语义作为显式的任务先验，构建了从感知到认知的完整映射。

本章的核心创新点在于设计了多模态提示生成模块MPGM与语义增强的动态路由模块MGRM。MPGM 利用预训练的视觉-语言模型将离散的任务描述转化为连续的高维语义提示，并通过字典学习机制对提示进行重构，使其兼具明确的语义指向性与图像内容适应性。MGRM 则将这些语义提示作为全局条件注入到门控网络中，与底层视觉特征深度融合，从而指导模型在该像素级和任务级做出更精准的专家选择。这种视觉+语义的双重驱动机制有效消除了仅靠纹理特征难以区分的任务边界，实现了更彻底的任务解耦。

实验结果表明，MAG-Net 在全色锐化、深度图超分及磁共振图像超分三个子任务上，不仅在一体化设置下显著优于现有通用模型及 VP-Net，而且在与各领域最先进的专用模型对比中也展现出了卓越的性能。消融实验进一步验证了引入文本语义提示对于缓解负迁移、促进正向知识共享的关键作用。MAG-Net 的成功探索证明了在高层语义指导下，单一模型完全有能力在处理异构多模态任务时兼顾通用性与专业性，为未来构建更智能、更通用的多模态图像复原系统提供了新的思路。