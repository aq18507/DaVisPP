function brushTest()
figure();
x=1:10;
plot(x.^2); 
hold on
plot(1:10);
h=brush;
set(h,'Enable','on','ActionPostCallback',@brushedDataCallback);
function brushedDataCallback(~,~)
h=findobj(gca,'type','line')
clear lineBrushed
for i=1:size(h)
      idx=get(h(i),'BrushData');
      idx=logical(idx);
      x=get(h(i),'XData');
      x=x(idx);
      idx=logical(idx);
      y=get(h(i),'YData');
      y=y(idx);
      lineBrushed(i,1,:)=x(1,:);
      lineBrushed(i,2,:)=y(1,:);
end
clear x
x(1,:)=lineBrushed(1,1,:)
y(1,:)=lineBrushed(1,2,:)
x(1,:)=lineBrushed(2,1,:)   
y(1,:)=lineBrushed(2,2,:)