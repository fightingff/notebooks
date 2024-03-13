# AI Materials

----

## CV

----

- [**CNN**](https://arxiv.org/abs/1409.1556)

    - The pioneering work of CNN. The paper introduces the **convolutional layer**, **pooling layer**, **fully connected layer**, and the implementation of the CNN model.

- [**transformer**](https://arxiv.org/abs/1706.03762)

    - The pioneering work of the transformer. The paper introduces the **self-attention** mechanism and the **multi-head attention** mechanism, as well as the implementation of the transformer model.

- [**GAN**](https://arxiv.org/abs/1406.2661)

    - The pioneering work of GAN, which introduces the **generator** and **discriminator** mechanism in GAN.

- [**cGAN**](https://arxiv.org/abs/1411.1784)

    - [Reference Blog](https://machinelearningmastery.com/how-to-develop-a-conditional-generative-adversarial-network-from-scratch/)
    
        - Help build a network from scrat 


    - [Deep Generative Image Models using a Laplacian Pyramid of Adversarial Networks](https://arxiv.org/pdf/1506.05751)

    - [ganhacks](https://github.com/soumith/ganhacks)
    
    - [pix2pix](https://arxiv.org/abs/1611.07004) 

- [**Unsupervised GAN**](https://arxiv.org/abs/1511.06434)

    - [Refernce Blog](https://machinelearningmastery.com/what-are-generative-adversarial-networks-gans/)
    
        - A detailed explanation of GAN and its implementation, as well as the **unsupervised GAN**.
        
    - [Tutorial: Generative Adversarial Networks](https://arxiv.org/abs/1701.00160) 
    
    - [CycleGAN (style transfer)](https://arxiv.org/pdf/1703.10593)
    
    - [CycleGAN (Chinese font transfer)](https://arxiv.org/pdf/1801.08624.pdf) 

----

## RNN

----

- [**word2vec**](https://arxiv.org/abs/1411.2738)

    - A detailed explanation of word2vec and its implementation **CBOW** & **SG**, as well as two optimization methods, **negative sampling** and **hierarchical softmax**. 

----

## Tips

----

- **CUDA restart**

```bash linenums="1"
sudo rmmod nvidia_uvm
sudo modprobe nvidia_uvm
```