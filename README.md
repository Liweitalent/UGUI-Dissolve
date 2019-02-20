# UGUI-Dissolve
让当前UI和子元素的UI都会一起消融
这个是之前一直想做的一个效果，年前也看到了开源的项目。
[原本的消融开源链接](https://github.com/mob-sakai/DissolveEffectForUGUI)
但是需求还是有点不太一样。我希望子UI也能够一起在相同的部位消融。简单来说，就是子UI和当前合并成一张纸，然后这张纸燃烧。而不是原本的多张碎纸片分开烧的样子。

在开源项目的shader上修改的方案，就是使用点在屏幕上位置，作为的噪声贴图采样的uv值。然后让噪声纹理支持纹理重复来控制密度。
我改写之后简单了很多，不擅长些Editor。最后上一下效果。
![内部有多个元素，而且也被溶解了](https://github.com/Liweitalent/UGUI-Dissolve/blob/master/Effect.gif)

[我在知乎上写的介绍](https://zhuanlan.zhihu.com/p/57200602)
