clear;

inequality = [];
equality = [];

inequality = xlsread('project_inequalities', 1);
equality = xlsread ('project_equalities', 1);
obj_func = xlsread ('project_obje', 1);


x_variables = 40;
num_variables = x_variables;


if isempty(inequality) ~= 1
      num_inequalityConstraints = length(inequality(:,1));
   else
      num_inequalityConstraints = 0;
end


if isempty(equality) ~= 1
      num_equalityConstraints = length(equality(:,1));
   else
      num_equalityConstraints = 0;
end

 f = zeros (1, num_variables);
Aineq=[];
bineq=[];
Aeq=[];
beq=[];

for i=1:num_variables
f(1,i)=obj_func(1,i);
end

if isempty(inequality)~=1
    for i=1:num_inequalityConstraints
        for j=1:(num_variables+1)
        if j<length(inequality(1,:))
        Aineq(i,j) = inequality(i,j);
        else
            bineq(i,1)= inequality(i,j);
        end
    end
end
end






if isempty(equality)~=1
    for i=1:num_equalityConstraints
        for j=1:(num_variables+1)
        if j<length(equality(1,:))
        Aeq(i,j) = equality(i,j);
        else
            beq(i,1)= equality(i,j);
        end
        end
    end
end




vtype=[];
for i=1:num_variables
   vtype=[vtype, 'C'];
end

sense=[];
for i= 1:num_inequalityConstraints
   sense=[sense, '<'];
end

for i=1:num_equalityConstraints
    sense=[sense, '='];
end

clear model;
model.obj = f;
model.A = sparse([Aineq; Aeq]);
model.rhs = [bineq; beq];
model.sense = sense;
model.vtype = vtype;
model.modelsense='max';
clear params;
params.outputflag = 1;
result = gurobi(model, params);
x = result.x;




%[x, fval]= linprog(f, Aineq, bineq, Aeq, beq)
