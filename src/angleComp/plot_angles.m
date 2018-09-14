%%PLOTS THE ANGLES of manual and automatically computed angles

%% 2018-03-08, root 4 -- totally off
% just 8 time steps

% theta_man = 0:7;
% theta_comp = 0:30;

theta_comp =        [90      50.1944 28.6105 22.9321 16.6992  3.8141  8.1301 0.0000];
theta_comp_input =  [55.0080 52.8831 30.9638 14.7436 23.1986 11.8887 14.0362 180-153.4349];
theta_man =         [83.5747 86.824  73.4753 62.7533 48.497  45      40.0743 34.2723];
    %32.573 33.6167 33.6187];

%time = 0:10:300;
time = [0 30 60 90 120 150 180 210]

plot(time, theta_comp)
hold on
plot(time, theta_comp_input)
hold on 
plot(time, theta_man)
grid on

title('Comparing the manually computed angle and the angle(s) computed by\it RootSkel', 'Interpreter', 'tex')
xlabel('Time [in mins]')
ylabel('Angle \Theta [in degrees]', 'Interpreter', 'tex')
legend('computed by\it RootSkel', 'computed with user input by\it RootSkel', 'computed manually','Location','northeast', 'Interpreter', 'tex')

%saveas(fig, plotAngles, png)

%% 2018-03-07, root 3 -- not complete, missing value in theta_man -- NOW GOOD

% pos 6, 8, 10, 11
% theta_comp =      [94.0856 85.4622 67.7510 63.4349 41.1859 45.0000 36.4692 44.1449 18.4349 12.5288 21.8014];
%     %180-162.1811];
theta_comp =        [94.0856 85.4622 67.7510 63.4349 41.1859 38.0214 36.4692 25.1449 18.4349 8.5288 1.8014];
theta_comp_input =  [95.0425 80.2176 57.2648 63.4349 43.2643 41.9872 37.5686 30.9638 18.4349 16.6992 4.3987];
    %0.0000];
theta_man =         [94.929  84.8987 63.063  56.137  47.375  32.471  34.981  20.264  17.1237 1.06   -8.608];

time = [0:30:300];

plot(time, theta_comp,'-o','MarkerSize',8)
hold on
plot(time, theta_comp_input,'-o','MarkerSize',8)
hold on 
plot(time, theta_man,'-o','MarkerSize',8)
set(gca,'fontsize',12.5)
% set(graph1,'LineWidth',2);
grid on

% title('2018-03-07, root 3:\newline Comparing the manually computed angle and the angle(s) computed by\it RootSkel\newline', 'Interpreter', 'tex')
title('2018-03-07, root 3:')
xlabel('Time [in mins]')
ylabel('Angle \Theta [in degrees]', 'Interpreter', 'tex')
legend('computed by\it RootSkel', 'computed with user input by\it RootSkel', 'computed manually','Location','northeast', 'Interpreter', 'tex')

print('2018-03-07','-dpng')

%% 2018-02-28, root 5 -- BEST EXAMPLE

% pos 8
% theta_comp =       [86.6335 69.7751 66.3706 63.4349 59.4208 56.9761 54.2461 55.0080 45.0010 47.8624 46.8476];
theta_comp =         [86.6335 69.7751 66.3706 63.4349 59.4208 56.9761 54.2461 50.0080 45.0010 47.8624 46.8476];
% pos 4
% theta_comp_input = [78.9591 69.4440 59.7436 51.3402 60.9454 56.8215 54.6375 49.9697 47.1211 46.4688 41.9872];
theta_comp_input =   [78.9591 69.4440 59.7436 61.3402 60.9454 56.8215 54.6375 49.9697 47.1211 46.4688 41.9872];
theta_man =          [82.861  76.168  70.4517 67.2077 61.0473 57.7337 51.0167 47.244  43.9957 49.5847 44.6373];

time = [0:30:300];

plot(time, theta_comp,'-o','MarkerSize',5)
hold on
plot(time, theta_comp_input,'-o','MarkerSize',5)
hold on 
plot(time, theta_man,'-o','MarkerSize',5)
set(gca,'fontsize',12.5)
grid on

%title('2018-02-28, root 5:\newline Comparing the manually computed angle and the angle(s) computed by\it RootSkel\newline', 'Interpreter', 'tex')
title('2018-02-28, root 5:')
xlabel('Time [in mins]')
ylabel('Angle \Theta [in degrees]', 'Interpreter', 'tex')
legend('computed by\it RootSkel', 'computed with user input by\it RootSkel', 'computed manually','Location','northeast', 'Interpreter', 'tex')

print('2018-02-28','-dpng')

%% 2018-04-24, root 2 -- GOOD EXAMPLE

% pos 8
% theta_comp =       [100.3048 92.2026 83.9559 55.0080 45.0000 48.3665 48.2397 60.4885 30.6997 10.3048 0];
theta_comp =       [100.3048 92.2026 83.9559 55.0080 45.0000 48.3665 48.2397 37.4885 30.6997 10.3048 0];
theta_comp_input = [93.5448  92.0454 71.5651 66.3706 58.6713 48.2397 40.8151 33.1113 30.6997 21.8014 0];
theta_man =        [95.3133  90      71.547  62.9943 56.047  46.5212 35.982  26.342  19.9737 15.743 12.7313];

time = [0:10:100];

plot(time, theta_comp,'-o','MarkerSize',5)
hold on
plot(time, theta_comp_input,'-o','MarkerSize',5)
hold on 
plot(time, theta_man,'-o','MarkerSize',5)
set(gca,'fontsize',12.5)
grid on

%title('2018-04-24, root 2:\newline Comparing the manually computed angle and the angle(s) computed by\it RootSkel\newline', 'Interpreter', 'tex')
title('2018-04-24, root 2:')
xlabel('Time [in mins]')
ylabel('Angle \Theta [in degrees]', 'Interpreter', 'tex')
legend('computed by\it RootSkel', 'computed with user input by\it RootSkel', 'computed manually','Location','northeast', 'Interpreter', 'tex')

print('2018-04-24','-dpng')
