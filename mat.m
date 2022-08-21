a.data = [1, 2];
b.data = [2.5, 4.75];
a.next = b;
a.prev = [];
b.next = [];
b.prev = a;

c.data = [6, 7];
c.next = [];
c.prev = b;

M = [a, b, c];


