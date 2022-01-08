function [output] = gray_mapping(input)
    left = 0;
    right = 255;
    output = zeros(size(input));
    for i = 1:1:size(input, 3)
        minimum = min(min(input(:, :, i)));
        maximum = max(max(input(:, :, i)));
        
        output(:, :, i) = (right-left)*(input(:, :, i)-minimum)/(maximum-minimum);
    end
    output = uint8(output);
end

