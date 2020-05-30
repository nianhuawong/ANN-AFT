if(min(a.x,b.x)<=max(c.x,d.x) && min(c.y,d.y)<=max(a.y,b.y)&&min(c.x,d.x)<=max(a.x,b.x) && min(a.y,b.y)<=max(c.y,d.y)) 
　　return true;

double u,v,w,z;//分别记录两个向量

u=(c.x-a.x)*(b.y-a.y)-(b.x-a.x)*(c.y-a.y);

v=(d.x-a.x)*(b.y-a.y)-(b.x-a.x)*(d.y-a.y);

w=(a.x-c.x)*(d.y-c.y)-(d.x-c.x)*(a.y-c.y);

z=(b.x-c.x)*(d.y-c.y)-(d.x-c.x)*(b.y-c.y);

return (u*v<=0.00000001 && w*z<=0.00000001);

因为double没法直接比较大小嘛，所以来看这篇博客的应该能看懂

/***************************************线段相交模板****************************************/
struct Point{//点
       double x,y;
       Point(){}
       Point(int a,int b){
              x=a;
              y=b;
       }
       void input(){//定义输入函数方便用的时候
              scanf("%lf%lf",&x,&y);
       }
};
struct Line{//线段
       Point a,b;
       Line(){}
       Line(Point x,Point y){
              a=x;
              b=y;
       }
       void input(){
              a.input();
              b.input();
       }
};
bool judge(Point &a,Point &b,Point &c,Point &d)
{
       /*
       快速排斥：
       两个线段为对角线组成的矩形，如果这两个矩形没有重叠的部分，那么两条线段是不可能出现重叠的
       */
       if(!(min(a.x,b.x)<=max(c.x,d.x) && min(c.y,d.y)<=max(a.y,b.y)&&min(c.x,d.x)<=max(a.x,b.x) && min(a.y,b.y)<=max(c.y,d.y)))//这里的确如此，这一步是判定两矩形是否相交
       //1.线段ab的低点低于cd的最高点（可能重合） 2.cd的最左端小于ab的最右端（可能重合）
       //3.cd的最低点低于ab的最高点（加上条件1，两线段在竖直方向上重合） 4.ab的最左端小于cd的最右端（加上条件2，两直线在水平方向上重合）
       //综上4个条件，两条线段组成的矩形是重合的
       /*特别要注意一个矩形含于另一个矩形之内的情况*/
       return false;
       /*
       跨立实验：
       如果两条线段相交，那么必须跨立，就是以一条线段为标准，另一条线段的两端点一定在这条线段的两段
       也就是说a b两点在线段cd的两端，c d两点在线段ab的两端
       */
    double u,v,w,z;//分别记录两个向量
    u=(c.x-a.x)*(b.y-a.y)-(b.x-a.x)*(c.y-a.y);
       v=(d.x-a.x)*(b.y-a.y)-(b.x-a.x)*(d.y-a.y);
       w=(a.x-c.x)*(d.y-c.y)-(d.x-c.x)*(a.y-c.y);
       z=(b.x-c.x)*(d.y-c.y)-(d.x-c.x)*(b.y-c.y);
       return (u*v<=0.00000001 && w*z<=0.00000001);
}

/***************************************线段相交模板****************************************/