#import "@preview/modern-ecnu-thesis:0.3.0": documentclass, indent, no-indent, word-count-cjk, total-words, bilingual-figure

= 相关理论与技术基础

== 引导式图像超分基础

=== 问题数学定义

引导式图像超分的核心目标是利用高分辨率的引导图像 $I_"guide"$ 作为辅助信息，将低分辨率的目标图像 $I_"LR"$ 重建为高分辨率图像 $I_"SR"$。假设 $I_"LR" in RR^(H times W times C_"in")$，$I_"guide" in RR^("sH" times "sW" times C_"guide")$，其中 $s$ 为超分倍率，$C_"in"$ 和 $C_"guide"$ 分别为目标图像和引导图像的通道数#[@tomasi1998bilateral, @kopf2007joint]。该过程可以抽象为一个非线性映射函数 $F$：

$ I_"SR" = F(I_"LR", I_"guide"; theta) approx I_"GT" , $

#{
set par(first-line-indent: 0pt)
[其中，$I_"SR" in RR^("sH" times "sW" times C_"in")$ 为重建结果，$I_"GT"$ 为对应的高分辨率真实标签，$theta$ 为模型参数。根据具体的应用场景，输入与输出的物理含义各不相同。以下将从全色锐化、深度图超分和磁共振图像超分三个子任务分别介绍各个值对应的物理含义。]
}
#heading(level: 4, numbering: none)[全色锐化]
全色锐化任务中，$I_"LR"$ 为低分辨率的多光谱图像（Multi-Spectral, MS），包含丰富的光谱信息；$I_"guide"$ 为高分辨率的全色图像（Panchromatic, PAN），包含清晰的空间几何结构。目标是生成既具有高空间分辨率又保留原始光谱特性的高分辨多光谱图像。如@fig:Pansharpening介绍 所示，全色锐化旨在将低分辨率多通道（4或8甚至更多）的多光谱图像与高分辨率的单通道全色图像融合，生成高分辨率的彩色图像。
#figure(
  caption: [全色锐化任务示意图。],
)[
#image("../images/02/Pansharpening介绍.png", width: 70%)
] <Pansharpening介绍>

#heading(level: 4, numbering: none)[深度图超分]
在深度图超分任务中，$I_"LR"$ 为低分辨率深度图，通常含有噪声；$I_"guide"$ 为同场景的高分辨率 RGB 彩色图像。如@fig:depth介绍 所示，目标是利用 RGB 图像的边缘纹理引导深度图的边缘恢复，同时防止纹理拷贝伪影。
#figure(
  caption: [深度图超分辨率任务示意图。],
)[
#image("../images/02/深度图超分介绍.png", width: 80%)
] <depth介绍>


#heading(level: 4, numbering: none)[磁共振图像超分]
磁共振图像超分辨率任务中，$I_"LR"$ 为低分辨率的某一模态 MR 图像（如 T2 加权像），扫描速度快但细节模糊；$I_"guide"$ 为高分辨率的另一模态 MR 图像（如 T1 加权像）。目标是利用 T1 的解剖结构细节信息辅助 T2 图像的重建。如@fig:MRI介绍 所示，通常利用 T1 加权像作为引导图像，增强 T2 加权像的空间分辨率。

#figure(
  caption: [磁共振图像超分辨率任务示意图。],
)[
#image("../images/02/MRI超分介绍.png", width: 70%)
] <MRI介绍>



=== 引导式图像超分任务评价指标

为了量化评估重建图像 $I_"SR"$ 与真实标签 $I_"GT"$ 之间的差异，本文采用了多种主流的客观评价指标。


#heading(level: 4, numbering: none)[峰值信噪比（PSNR）]
    PSNR 是最常用的图像质量评价指标，基于均方误差（MSE）计算，单位为 dB。对于 $N$ 位深度的图像，计算公式如下：
    $ "MSE" = 1 / ("sH" times "sW" times C_"in") ||I_"SR" - I_"GT"||_2^2 , $
    $ "PSNR" = 10 dot log_10 ((2^N - 1)^2 / "MSE") , $
    #{
    set par(first-line-indent: 0pt)
    [其中，$I_"SR"$ 和 $I_"GT"$ 分别表示重建图像和真实高分辨率图像，$"sH" times "sW"$ 为图像的空间分辨率，$C_"in"$ 为图像通道数。$2^N - 1$ 代表图像像素可能达到的最大数值（如 8 位图像为 255）。PSNR 值越高，表示重建图像在像素级上越接近真实值，图像失真越小。]
    }

#heading(level: 4, numbering: none)[结构相似度（SSIM）]
    SSIM 从亮度（Luminance）、对比度（Contrast）和结构（Structure）三个维度衡量图像的相似性，更符合人眼的视觉感知特性。其计算公式为：
    $ "SSIM"(x, y) = ((2 mu_x mu_y + c_1)(2 sigma_"xy" + c_2)) / ((mu_x^2 + mu_y^2 + c_1)(sigma_x^2 + sigma_y^2 + c_2)) , $
    #{
    set par(first-line-indent: 0pt)
    [其中，$x$ 和 $y$ 分别代表从重建图像和真实图像中提取的图像块。$mu_x, mu_y$ 分别为 $x$ 和 $y$ 的均值，反映亮度信息；$sigma_x^2, sigma_y^2$ 分别为 $x$ 和 $y$ 的方差，反映对比度信息；$sigma_"xy"$ 为协方差，反映结构相似性。$c_1$ 和 $c_2$ 为常数，用于避免分母为零的情况（通常取 $c_1=(k_1 L)^2, c_2=(k_2 L)^2$，其中 $L$ 为像素值的动态范围，$k_1=0.01, k_2=0.03$）。SSIM 取值范围为 $[0, 1]$，值越接近 1 表示结构保留越完整。]
    }


#heading(level: 4, numbering: none)[均方根误差（RMSE）]
    RMSE 常用于深度图超分任务，直接反映深度值的预测偏差。其计算公式为：
    $ "RMSE" = sqrt(1 / ("sH" times "sW") ||I_"SR" - I_"GT"||_2^2) , $
    #{
    set par(first-line-indent: 0pt)
    [其中，$|| dot ||_2$ 表示 L2 范数。RMSE 通过计算重建图像与真实图像对应像素差值的平方和的均值再开方，能够敏感地反映出图像中的大误差。RMSE 值越低，表示深度恢复越准确。]
    }
    
#heading(level: 4, numbering: none)[光谱角映射（SAM）]
    SAM 专门用于评估全色锐化任务中的光谱失真程度，通过计算重建图像与真实图像在每个像素位置上的光谱向量之间的夹角来度量。公式如下：
    $ "SAM"(bold(v), hat(bold(v))) = arccos((bold(v) dot hat(bold(v))) / (||bold(v)||_2 dot ||hat(bold(v))||_2)) , $
    #{
    set par(first-line-indent: 0pt)
    [其中，$bold(v)$ 和 $hat(bold(v))$ 分别表示真实多光谱图像和重建全色锐化图像在同一像素位置的光谱向量（向量长度等于波段数）。SAM 计算的是这两个向量在光谱空间中的角度，与光照强度无关。SAM 值通常以度或弧度为单位，值越小，表示重构图像的光谱特性（即波段间的相对比例关系）保持得越好。]
    }
    
#heading(level: 4, numbering: none)[综合相对全局误差（ERGAS）]
    ERGAS 综合考虑了空间分辨率与光谱质量，是一个全局性的误差指标，尤其适用于评估多波段图像的融合质量。其公式为：
    $ "ERGAS" = 100 / s sqrt(1 / C_"in" sum_(i=1)^(C_"in") ("RMSE"_i / mu_i)^2) , $
    #{
    set par(first-line-indent: 0pt)
    [其中，$s$ 为高分辨率全色图像与低分辨率多光谱图像的空间分辨率之比（即超分倍率）；$C_"in"$ 为波段总数；$"RMSE"_i$ 为第 $i$ 个波段的均方根误差；$mu_i$ 为第 $i$ 个波段的像素均值。ERGAS 值越低，表示在考虑了各波段亮度水平和缩放比例后的整体融合质量越高。]
    }
    

== 一体化图像恢复相关基础

=== Transformer与ViT

近年来，Transformer架构凭借自注意力机制在自然语言处理领域的颠覆性成功，被Dosovitskiy等人@dosovitskiy2020image 以Vision Transformer (ViT)的形式引入计算机视觉。不同于传统CNN依赖局部感受野的卷积操作，ViT将图像分割为非重叠Patch并展平为序列，利用多头自注意力机制捕捉全局长距离依赖，这使其更适合处理高分辨率图像中的复杂纹理结构。
然而，标准ViT的计算复杂度随图像分辨率呈二次方增长，在底层视觉任务中面临巨大的显存与计算挑战。Liu等人@liu2021swin 提出的Swin Transformer通过基于移位窗口的局部注意力机制，将计算复杂度降至线性。随后，SwinIR @liang2021swinir 进一步将其应用于图像复原，凭借高质量的局部-全局特征表征刷新了多项基准。

为进一步平衡计算效率与特征捕捉能力，图像复原领域的Transformer架构持续演进。Zamir等人@allinone_zamir2022restormer 提出的Restormer架构通过多头门控通道注意力（MDTA）将计算转移至通道维度，不仅规避了高分辨率输入的显存瓶颈，还利用门控前馈网络增强了非线性表达。此后，Uformer @wang2022uformer 和HAT @chen2023activating 等工作分别通过U型结构和混合注意力机制，进一步提升了多尺度特征捕获与边缘保真度。

=== Restormer及核心组件

本文提出的VP-Net与MAG-Net均采用Restormer作为基础骨干网络。Restormer专为图像复原任务设计，能够在保持计算效率的同时有效提取多尺度特征，其整体采用了多尺度分层设计，核心组件包括多头转置注意力机制（MDTA）和门控前馈网络（GDFN）。


#heading(level: 4, numbering: none)[多头转置注意力机制]
    传统的自注意力机制（如ViT中使用的）计算复杂度与图像像素数量的平方成正比（$O((H W)^2)$），在高分辨率图像处理中显存开销巨大。Restormer提出的MDTA将注意力计算从空间维度转移到了通道维度。假设输入特征为 $X in RR^(H times W times C)$，MDTA首先生成查询（Query）、键（Key）和值（Value）投影：$Q, K, V in RR^(H times W times C)$。然后将特征重塑为 $RR^("HW" times C)$，并在通道维度计算注意力图：
    $ "Attention"(Q, K, V) = V dot "Softmax"((K^T Q) / alpha) , $
    #{
    set par(first-line-indent: 0pt)
    [其中，$K^T Q$ 生成的是 $C times C$ 的协方差矩阵，而非传统的 $"HW" times "HW"$ 空间注意力图。这使得计算复杂度降低为 $O(H W C)$，与图像分辨率呈线性关系，极大提升了处理高分辨率图像的效率。此外，$alpha$ 是一个可学习的缩放参数，用于调节注意力图的幅度。]
    }

#heading(level: 4, numbering: none)[门控前馈网络]
    标准Transformer中的前馈网络（FFN）通常由两个全连接层和GELU激活函数组成。Restormer引入了门控前馈网络GDFN来增强特征变换的非线性表达能力。GDFN包含两个并行的路径，通过 $1 times 1$ 卷积扩展通道数，接着使用 $3 times 3$ 深度可分离卷积（Depth-wise Convolution）来编码具备空间局部性的上下文信息。其中一条路径经过GELU激活后作为门控信号，与另一条路径进行逐元素相乘：
    $ X_"out" = W_p^0 ("GELU"(W_d^1 (W_p^1 (X))) dot.circle W_d^2 (W_p^2 (X))) , $
    #{
    set par(first-line-indent: 0pt)
    [其中，$dot.circle$ 表示逐元素乘法，$W_p$ 表示 $1 times 1$ 点卷积，$W_d$ 表示 $3 times 3$ 深度卷积。这种门控机制允许网络有选择地传递信息流，从而更精细地控制特征的激活与抑制。]
    }
    

=== 混合专家系统基本原理
混合专家系统（Mixture-of-Experts, MoE）@moe_original 是一种条件计算模型，旨在通过增加模型容量而不增加计算量来提升性能。MoE的核心思想是将一个大的神经网络分解为多个并行的子网络，即专家（Experts），并引入一个门控网络（Gating Network）来决定对于每一个输入样本，应该激活哪些专家进行处理。
假设有 $N$ 个专家网络 ${E_1, E_2, dots, E_N}$，对于输入 $x$，MoE的输出 $y$ 可以表示为各专家输出的加权和：
$ y = sum_(i=1)^N G(x)_i E_i(x) , $
#{
set par(first-line-indent: 0pt)
[其中，$G(x)$ 是门控网络的输出向量，$G(x)_i$ 表示第 $i$ 个专家的权重。在深度学习中，MoE通常被嵌入到Transformer的FFN层或卷积层中，使得模型能够针对不同的输入模式（如不同的语义、纹理或模态）学习专门的参数表示。如@fig:moe 所示，门控网络根据输入决定激活哪些专家，并将各专家的输出进行加权聚合。]
}



#figure(
  caption: [混合专家系统 (MoE) 架构示意图。],
)[
#image("../images/02/MOE.png", width: 60%)
] <moe>



#heading(level: 4, numbering: none)[Top-K稀疏路由]
    为了保证推理效率，MoE通常采用稀疏路由策略，即对于每个输入，只激活一小部分专家。该策略通过噪声门控、Top-K筛选与概率归一化三个环节实现高效的条件计算。

    为了增加探索性并促进负载均衡，模型首先计算带有可学习噪声的门控分数：
    $ H(x) = x dot W_g + "SN"() dot "Softplus"(x dot W_"noise") , $
    #{
    set par(first-line-indent: 0pt)
    [其中，$x$ 为输入特征，$W_g$ 为门控网络的权重矩阵，$"SN"()$ 表示标准正态分布采样，$"Softplus"$ 为激活函数，$W_"noise"$ 为可学习的噪声参数矩阵。]
    }

    随后，为了实现计算的稀疏性，模型执行Top-K筛选操作，仅保留得分最高的 $k$ 个专家，将其余专家的得分置为负无穷：
    $ "TopK"(v, k)_i = cases(v_i & "if" v_i "is in top" k "elements", -infinity & "otherwise") . $

    最后，通过Softmax函数将保留下来的得分转化为概率分布，作为各专家的权重：
    $ G(x) = "Softmax"("TopK"(H(x), k)) . $
    #{
    set par(first-line-indent: 0pt)
    [这种机制使得门控网络 $G(x)$ 具有稀疏性，在拥有极大规模参数量的同时，实际计算量仅与被激活的 $k$ 个专家相关。]
    }
    


    在MoE训练过程中，常见的挑战是路由坍缩现象，即门控网络倾向于将大多数样本分配给少数几个表现较好的专家，导致这些专家过载，而其他专家处于闲置状态。这不仅浪费了模型容量，也限制了专家的专业化分工。为了解决这一问题，通常会引入负载均衡损失：
    $ cal(L)_"balance" = N dot sum_(i=1)^N f_i dot P_i , $
    #{
    set par(first-line-indent: 0pt)
    [其中，$N$ 是专家数量，$f_i$ 是第 $i$ 个专家在当前Batch中被选中的频率，$P_i$ 是第 $i$ 个专家的平均累积门控概率。最小化该损失函数将鼓励所有专家被接收相等数量的样本，且具有相近的平均重要性。]
    }
    

== 多模态预训练模型与提示学习

=== 视觉-语言大模型

视觉-语言预训练模型旨在建立图像与文本之间的语义关联。OpenAI提出的CLIP（Contrastive Language-Image Pre-training）@radford2021learning 是其中的里程碑式工作。如@fig:CLIP 所示，CLIP包含一个文本编码器（Text Encoder, 通常是Transformer）和一个图像编码器（Image Encoder, ResNet或ViT）。

#figure(
  caption: [CLIP模型架构示意图。],
)[
#image("../images/02/CLIP.png", width: 90%)
] <CLIP>


CLIP的核心创新在于通过大规模的对比学习，将图像和其对应的文本描述映射到一个共享的联合嵌入空间。在该空间中，匹配的图像-文本对（正样本）的特征向量余弦相似度被最大化，而不匹配的对（负样本）则被最小化。这使得CLIP具备了强大的零样本（Zero-shot）迁移能力和跨模态语义对齐能力，能够理解具有丰富语义的文本指令。

=== 提示学习

提示学习（Prompt Learning）最初起源于自然语言处理领域，旨在通过设计特定的输入Prompt来激发预训练大语言模型处理下游任务的能力，而无需微调整个模型参数。提示可以分为两类：
1.  硬提示：由人类专家手工设计的离散文本字符，例如“把这句话翻译成中文”。
2.  软提示：由可学习的连续向量组成，通过反向传播在特定任务上进行优化。

如@fig:prompt 所示，在计算机视觉及多模态领域，提示学习被引入用于适应不同的视觉任务。通过将任务描述（如“去噪”、“超分”、“风格迁移”）转化为提示向量注入到模型中，可以动态调整模型的行为。

#figure(
  caption: [提示学习 (Prompt Learning)在图像复原中的应用示意图。],
)[
#image("../images/02/Prompt.png", width: 100%)
] <prompt>

在GISR任务中，引入提示学习的意义在于：传统模型对全色锐化等任务差异缺乏显式的认知。通过利用CLIP等视觉-语言预训练模型提取任务描述的语义特征作为提示，可以赋予底层视觉模型对高层任务意图的理解能力，从而指导模型根据具体的任务需求（如保持光谱一致或恢复几何结构）进行针对性的图像重建。

== 本章小结

本章系统梳理了引导式图像超分及一体化模型的理论基础。首先阐述了引导式超分的数学定义，并介绍了全色锐化等三个子任务的物理含义与评价体系。然后回顾了一体化恢复技术基础，阐述了Restormer骨干网络、混合专家系统以及多模态提示学习原理。
