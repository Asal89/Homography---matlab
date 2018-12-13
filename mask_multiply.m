function [ masked_image ] = mask_multiply( I1, mask )
%TODO: description of this function

masked_image = bsxfun(@times, I1, cast(mask, 'like', I1));

end

