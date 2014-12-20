%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) Javier Sánchez Monedero (jsanchezm at uco dot es)
% 
% This code implements the Pairwise Class Distances (PCD) projection and the
% associated PCD Ordinal Classifier (PCDOC).
% 
% The code has been tested with Ubuntu 11.04 x86_64 and Matlab R2009a
% 
% If you use this code, please cite the associated paper
% Code updates and citing information:
% http://www.uco.es/grupos/ayrna/neco-pairwisedistances
% 
% AYRNA Research group's website:
% http://www.uco.es/ayrna 
%
% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 3
% of the License, or (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA. 
% Licence available at: http://www.gnu.org/licenses/gpl-3.0.html
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clearvars;
addpath tools/

load SyntheticLinearOrder.mat;

% Choose what to paint
% Paint patterns
paintX = true;
% Paint min distances
paintlines = true;
% Ratio of wow many distances will be painted
paintlineRatio = 1;
% Paint projection histograms
painthist = true;

% Line width and colours definitions
MarkerSizeValue = 7;
LineWidthValue = 2;

verde = [0.2,0.7,0.2];
gris = [0.7,0.7,0.7];

% Relevant points to paint. Z values of the PCD projection will be painted
% for these points
PointClass1 = [2.0125 -0.0664;-0.1414 -0.6614;-0.4608 1.1212;-3.2640 -2.7955;-2.3187 -3.7712;-2.0330   -0.6328];
PointClass2 = [3.142 0.1803;2.8559    3.0370;1.7369    3.2760; 1.3585    1.6836];
PointClass3 = [6.2040    4.9904;3.3522    5.2332;3.7801    2.4945;6.101 4.947];
PointClass4 = [8.2231    6.1212;6.1069    5.6002;7.2196    6.9221];


if paintX
    figure; hold on; axis square;
    % If you want to zoom into the plot, descomment the following line
    %axis([-30 5 -5 30])
    plot(X(Y==1,1),X(Y==1,2),'r+','MarkerSize',MarkerSizeValue)
    plot(X(Y==2,1),X(Y==2,2),'b.','MarkerSize',MarkerSizeValue*2.5)
    plot(X(Y==3,1),X(Y==3,2),'^','MarkerSize',MarkerSizeValue,'Color',verde)
    plot(X(Y==4,1),X(Y==4,2),'k*','MarkerSize',MarkerSizeValue)
    legend_handle = legend('class 1','class 2','class 3','class 4');
    legend(legend_handle ,'Location','NorthWest');
end

[Z,ZC,Dmin,DminIdx,NC] = pcdprojection(X,Y,Q);


if paintlines 
% PAINTING
axis square;
    for i = 1:Q-1
        j = i + 1;
            Ni=size(X(Y==i,:),1);
            Nj=size(X(Y==j,:),1);

            Xsub = [X(Y==i,:);X(Y==j,:)];
            temp = DminIdx{i,j};
            tempdist = Dmin{i,j};
            for pattern=1:Ni
                if rand <= paintlineRatio
                    % Hack for painting some patterns. min(abs(diff)) <
                    % 0.01 is necesary due to different number precissions 
                    punto = [Xsub(pattern,1) Xsub(pattern,2)];
                    
                    switch(i)
                        case 1
                            diff = PointClass1-repmat(punto,size(PointClass1,1),1);
                            if min(abs(diff)) < 0.01
                                plotThisPoint = true;
                            else
                                plotThisPoint = false;
                            end

                            if  plotThisPoint
                                plot([Xsub(pattern,1) Xsub(temp(pattern),1)],...
                                    [Xsub(pattern,2) Xsub(temp(pattern),2)],'r-','LineWidth',LineWidthValue);
                            end
                        case 2
                            diff = PointClass2-repmat(punto,size(PointClass2,1),1);
                            if min(abs(diff)) < 0.001
                                plotThisPoint = true;
                            else
                                plotThisPoint = false;
                            end
                            
                            if plotThisPoint
                                plot([Xsub(pattern,1) Xsub(temp(pattern),1)],...
                                    [Xsub(pattern,2) Xsub(temp(pattern),2)],'b-','LineWidth',LineWidthValue);
                            end
                        case 3
                            
                            diff = PointClass3-repmat(punto,size(PointClass3,1),1);
                            if min(abs(diff)) < 0.001
                                plotThisPoint = true;
                            else
                                plotThisPoint = false;
                            end
                            
                            if plotThisPoint
                                plot([Xsub(pattern,1) Xsub(temp(pattern),1)],...
                                    [Xsub(pattern,2) Xsub(temp(pattern),2)],'-','Color',verde,'LineWidth',LineWidthValue);
                            end
                    end
                end
            end

            for pattern=Ni+1:Ni+Nj
                if rand <= paintlineRatio
                    punto = [Xsub(pattern,1) Xsub(pattern,2)];
                    
                    switch(j)
                        case 2
                            diff = PointClass2-repmat(punto,size(PointClass2,1),1);
                            if min(abs(diff)) < 0.001
                                plotThisPoint = true;
                            else
                                plotThisPoint = false;
                            end
                            
                            if plotThisPoint
                                plot([Xsub(pattern,1) Xsub(temp(pattern),1)],...
                                    [Xsub(pattern,2) Xsub(temp(pattern),2)],'b--','LineWidth',LineWidthValue);
                            end
                        case 3
                            diff = PointClass3-repmat(punto,size(PointClass3,1),1);
                            if min(abs(diff)) < 0.001
                                plotThisPoint = true;
                            else
                                plotThisPoint = false;
                            end
                            
                            if plotThisPoint
                                plot([Xsub(pattern,1) Xsub(temp(pattern),1)],...
                                    [Xsub(pattern,2) Xsub(temp(pattern),2)],'--','Color',verde,'LineWidth',LineWidthValue);
                            end
                        case 4
                            diff = PointClass4-repmat(punto,size(PointClass4,1),1);
                            if min(abs(diff)) < 0.001
                                plotThisPoint = true;
                            else
                                plotThisPoint = false;
                            end
                            
                            if plotThisPoint
                                plot([Xsub(pattern,1) Xsub(temp(pattern),1)],...
                                    [Xsub(pattern,2) Xsub(temp(pattern),2)],'k--','LineWidth',LineWidthValue);
                            end
                    end
                end
            end
    end
end

poffset = 0;
for i=1:Q
    temp = ZC{i,1};
    
    if paintX
        for n=1:NC(i)
            punto = [X(poffset+n,1) X(poffset+n,2)];
            PointClass = [PointClass1;PointClass2;PointClass3;PointClass4];
            
            diff = PointClass-repmat(punto,size(PointClass,1),1);
            if min(abs(diff)) < 0.001
                plotThisPoint = true;
            else
                plotThisPoint = false;
            end
                            
            if plotThisPoint
                plot(X(poffset+n,1),X(poffset+n,2),'o','Color',gris,'MarkerSize',MarkerSizeValue*1.5);
                text(X(poffset+n,1),X(poffset+n,2),num2str(temp(n,1)));
            end
        end
    end
  
    poffset=poffset+NC(i);
end

hold off;

% width 
width = 1/Q;
% maximum Z value
maxZ = 1;
% Thressholds used for classification purposes when predicting
% new values of Z for unseen data. 
thresshold = width:width:maxZ;

if painthist
    %On color histogram
    %histPrecision=200;
    %figure;hist(Z,histPrecision);hold on;
    %plot(thresshold,zeros(size(thresshold)),'+r'); 
    %legend_handle = legend('class 1','class 2','class 3','class 4');
    %legend(legend_handle ,'Location','NorthEast');
    %hold off;
    
    histPrecision=200/Q;
    figure;hold on;
    hist(ZC{1,1},histPrecision);
    hist(ZC{2,1},histPrecision);
    hist(ZC{3,1},histPrecision);
    hist(ZC{4,1},histPrecision);
    h = findobj(gca,'Type','patch');

    set(h(4),'FaceColor','r','EdgeColor','r');
    set(h(3),'FaceColor','b','EdgeColor','b');
    set(h(2),'FaceColor',verde,'EdgeColor',verde);
    set(h(1),'FaceColor','k','EdgeColor','k');
    
    legend_handle = legend('class 1','class 2','class 3','class 4');
    legend(legend_handle ,'Location','NorthEast');

    plot(thresshold,zeros(size(thresshold)),'+r'); % puntos de corte de decisión
    hold off;
end
