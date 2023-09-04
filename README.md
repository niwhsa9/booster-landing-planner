# landing-planner
Direct collocation trajectory optimization for a reusable rocket booster system

https://www.youtube.com/watch?v=K-U8K1ciSDg

![Demo run](https://github.com/niwhsa9/landing-planner/blob/main/anim.gif?raw=true)

This planner optimizes a trajectory for a 2 dimensional rocket with the following dynamics: 

$$ \begin{bmatrix}
    \ddot{x} \\
    \ddot{y} \\
\end{bmatrix} =
R^{world}_{ship} \begin{bmatrix}
    \frac{F}{m} \cos \alpha \\
    \frac{F}{m} \sin \alpha
\end{bmatrix}
\begin{bmatrix}
    \ddot{x} \\
    \ddot{y} \\
\end{bmatrix}
+
\begin{bmatrix}
    0 \\
    -9.8 \\
\end{bmatrix}$$

$$\ddot{\theta} = \frac{-F \sin \alpha}{I} \frac{h}{2}$$

$$\dot{f} = kF$$

The trajectory satisfies:
$$z^* = \arg\min_{z_t} f_T$$
