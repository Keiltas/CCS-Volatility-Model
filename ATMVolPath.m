classdef ATMVolPath
   properties
       leftBound;
       rightBound;
       type;
       
       path;
      
   end
   methods
      function obj = ATMVolPath(xCoord, yCoord)
          if ((size(xCoord, 1) ~=  size(yCoord, 1)) || (size(xCoord, 2) ~=  size(yCoord, 2)))
            error('Dimensions of x and y coordinates have to b equal.');
          end
          if ((size(xCoord, 1) ~=  1) || (size(yCoord, 1) ~=  1))
            error('x and y coordinates are assumed to be row vectors.');
          end
          
          % Between these two points, the ATM volatility path is built. 
          % Beyond them, volatility stays constant (with value equal to one on the corresponding boundary)
          obj.leftBound(1) = min(xCoord);
          obj.rightBound(1) = max(xCoord);
          
          syms x y;
          if (size(xCoord, 2) ==  1)
              % ATM volatility input consists of a single point, path is constant in this case. 
              obj.type = 1;
              obj.path = yCoord(1);
              obj.leftBound(2) = yCoord(1);
              obj.rightBound(2) = yCoord(1);
  
          elseif (size(xCoord, 2) ==  2)
              % ATM volatility input consists of two points, path is linear. 
              obj.type = 2;
              A  = [ x y 1; xCoord(1) yCoord(1) 1; xCoord(2) yCoord(2) 1];
              obj.path = double(coeffs(solve(det(A),y), 'All'));
              obj.leftBound(2) = polyval(obj.path, obj.leftBound(1));
              obj.rightBound(2) = polyval(obj.path, obj.rightBound(1));
              
          elseif (size(xCoord, 2) ==  3)
              % ATM volatility input consists of three points, path is a parabola. 
              obj.type = 3;
              A  = [x^2 x y 1; xCoord(1)^2 xCoord(1) yCoord(1) 1; xCoord(2)^2 xCoord(2) yCoord(2) 1; xCoord(3)^2 xCoord(3) yCoord(3) 1];
              obj.path = double(coeffs(solve(det(A),y), 'All')); 
              obj.leftBound(2) = polyval(obj.path, obj.leftBound(1));
              obj.rightBound(2) = polyval(obj.path, obj.rightBound(1));              
          elseif (size(xCoord, 2) >  3)
              % ATM volatility input consists of three points, path is a parabola. 
              obj.type = 4;
              obj.path  = csape(xCoord, [ 0 yCoord 0 ],  [2 2]);    
              % still a question of boundary conditions

              obj.leftBound(2) = ppval(obj.path, obj.leftBound(1));
              obj.rightBound(2) = ppval(obj.path, obj.rightBound(1));              
          end
          
      end
%       function obj = ATMVolPath(InputFile)
%           run(InputFile);
%           ATMVolPath(xCoord, yCoord);
%       end    
      % Calculate ATM volatility at a given point x.
      function value = GetValue(obj, x)
          if (x > obj.rightBound(1))
              value = obj.rightBound(2);
              return
          elseif (x < obj.leftBound(1))
              value = obj.leftBound(2);
              return
          end
          if (obj.type ==  1)
              value = obj.path;
          elseif ((obj.type ==  2) || (obj.type ==  3))
              value = polyval(obj.path, x); 
          elseif (obj.type ==  4)
              value  = ppval(obj.path, x);
          end 
      
      end
   end
end



