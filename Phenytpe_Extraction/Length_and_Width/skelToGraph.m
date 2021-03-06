% IOWA STATE UNIVERSITY

%   Developed by Seyed Vahid Mirnezami September 27, 2018 -
%   vahid@iastate.edu - vahid.gvg@gmail.com
    
%   Copyright 2017-2018 Prof. Baskar Ganapathysubramanian -
%   baskarg@iastate.edu 



% SkelToGraph functions is used to convert the skeleton image to the graph mode.

% Inputs: skelton image.
% Output: graph mode of the skeleton image.

function [DistMat]=skelToGraph(skeBW)
    [y,x] = find(skeBW);
    Pt = [y x];
    %find distance matrix between all these useful point
    % [null] = Func_Diagnostic('Computing Distance Matrix...');
    % waitbar(0.375,h,'Computing Distance Matrix..')
    [IDX,D] = knnsearch(Pt,Pt,'K',10);

    %removes self counting
    D(:,1)= [];
    IDX(:,1) = [];
    %preallocates the distance matrix
    DistMat = sparse(max(size(y)));
    k = 0;

    for i=1:size(y,1)
        %you are at node i

        %find neighbors ID
        NN = find( D(i,:) < 2);
        if NN == 1;
            %%change name
            leaf_ID(k+1) = IDX(i,NN);
            k = k+1;
        end
        NN_ID = IDX(i,NN);
        n_NN_ID = max(size(NN_ID));

        %find distance from NN_ID to i
        for j=1:n_NN_ID
            DistMat(i,NN_ID(j)) = D(i,NN(j));
            DistMat(NN_ID(j),i) = D(i,NN(j));
        end
    end
end