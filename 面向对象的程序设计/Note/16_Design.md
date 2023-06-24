牛顿法求根

$\huge x_{n+1} = x_n - \frac{f(x_n)}{f'(x_n)}$

类(OOP)编程太多了懒得写

函数式编程代码抄一下：

```cpp
#include <cmath>
#include <iostream>

using fn = std::function<double(double)>;

inline void print_info(int k, double x, double fx) {
    using namespace std;
    cout << "k = " << k << ", x = " << x << ", f(x) = " << fx << endl;
}

inline bool is_close(double fx, double tolerance) {
    return std::fabs(fx) < tolerance;
}

double newton_solve(fn f, fn df, double x0, double tolerance = 1e-12, int max_iters = 30) {
    int k = 0;
    double x = x0;
    print_info(k, x, f(x));

    while (!is_close(f(x), tolerance) && (k++ < max_iters)) {
        x = x - f(x) / df(x);
        print_info(k, x, f(x));
    }
    return x;
}

double sqrt_newton(double a, double x0 = 1.0) {
    auto f  = [a](double x) { return x * x - a; };
    auto df = [](double x) { return 2 * x; };
    return newton_solve(f, df, x0);
}

double nth_root_newton(double a, int n, double x0 = 1.0) {
    auto f  = [a, n](double x) { return std::pow(x, n) - a; };
    auto df = [n](double x) { return n * std::pow(x, n - 1); };
    return newton_solve(f, df, x0);
}

int main(int argc, char const *argv[]) {
    sqrt_newton(2.0);
    nth_root_newton(64, 3);
    return 0;
}

```

