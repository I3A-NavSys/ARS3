clc

plot(out.AC1pos.Data(:,1),out.AC1pos.Data(:,2),'r');
axis equal
grid on
hold on

ac1 = out.AC1pos.Data(end,:)

plot(out.AC2pos.Data(:,1),out.AC2pos.Data(:,2),'b');

ac2 = out.AC2pos.Data(end,:)

dist = norm(ac2-ac1)
