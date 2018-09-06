
function point_get(minnum,maxnum,srcx,srcy,relevant_axes)
  % The function asks the users for point as long as he doesn't choose a
  % legal number, defined as a number of points between minimum and maximum.
  % The srcx and srcy are strings with the name of the variable that will
  % receive the data in the base workspace
  
  % 10.8.18, 23:54 was forced to add the relevant_axes variable to prevent
  % discrepancy with the root tip
  flag = 0;
  while (flag == 0)
      [tempx,tempy] = getpts(relevant_axes);
      tempsize = size(tempx);
      if ( (tempsize(1) < minnum) | (tempsize(1) > maxnum) )
          if (tempsize(1) < minnum)
              uiwait(msgbox('Not enough points. Try again','User instructions','modal'));
          else
              uiwait(msgbox('Too many points. Try again','User instructions','modal'));
          end
      else
          flag = 1;
      end
  end
  % Sending the data to the calling workspace
  % The srcx and srcy are important because they are the string that tell
  % assignin in which variable in the caller to store the data.
  assignin('caller',srcx,tempx)
  assignin('caller',srcy,tempy)
end