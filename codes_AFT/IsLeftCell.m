function flag = IsLeftCell( node1, node2, node3, xCoord, yCoord)

flag = 0;

vector_base = [xCoord(node2)-xCoord(node1), yCoord(node2)-yCoord(node1), 0];
vector_new  = [xCoord(node3)-xCoord(node1), yCoord(node3)-yCoord(node1), 0];

x1 = vector_base(1);
y1 = vector_base(2);
x2 = vector_new(1);
y2 = vector_new(2);

res = x1*y2 - x2*y1;

if(res>0)  %×óµ¥Ôª
    flag = 1;
end