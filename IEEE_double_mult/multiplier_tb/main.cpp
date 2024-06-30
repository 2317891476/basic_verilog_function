/*
 * @Description: 
 * @version: 
 * @Author: charles
 * @Date: 2024-04-22 11:53:17
 * @LastEditors: charles
 * @LastEditorHomePage: https://gitee.com/tang_jixuan
 * @LastEditTime: 2024-04-22 11:53:18
 */
#include <string>
#include <random>
#include <fstream>
#include <iostream>

using namespace std;

int main()
{
    double min = __DBL_MIN__, max = sqrtl(__DBL_MAX__);
    random_device seed;                                                                  // 硬件生成随机数种子
    ranlux48 engine(seed());                                                             // 利用种子生成随机数引擎
    uniform_real_distribution<double> distrib(logl(pow(min, 0.8)), logl(pow(max, 0.95))); // 设置随机数范围，并为均匀分布
    ofstream fout("dataset.dat", ios_base::out);
    for (int i = 0; i < 20; i++)
    {
        double random_a = powl(10, distrib(engine)); // 随机数
        double random_b = powl(10, distrib(engine)); // 随机数
        double random_c = random_a * random_b;
        cout << random_a << " " << random_b << " " << random_c << endl;
        fout << hex << *((long long int *)(&random_a)) << " "
             << *((long long int *)(&random_b)) << " "
             << *((long long int *)(&random_c)) << endl;
    }
}