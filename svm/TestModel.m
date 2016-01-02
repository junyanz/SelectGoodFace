function [pred] = TestModel(data, model)
weights = zeros([size(data, 1), 1]); 
pred = svmpredict(weights, data, model, '-q'); 
end

