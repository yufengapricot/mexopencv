classdef TestThreshold
    %TestThreshold

    methods (Static)
        function test_result
            img = rand(100, 'single');
            result = cv.threshold(img, 0.5, 'MaxValue',1.0);
            validateattributes(result, {class(img)}, {'size',size(img)});
        end

        function test_threshold_types
            img = cv.imread(fullfile(mexopencv.root(),'test','sudoku.jpg'), 'Grayscale',true);
            types = {'Binary', 'BinaryInv', 'Trunc', 'ToZero', 'ToZeroInv'};
            for i=1:numel(types)
                result = cv.threshold(img, 127, 'MaxValue',255, 'Type',types{i});
                validateattributes(result, {class(img)}, {'size',size(img)});
            end
        end

        function test_auto_threshold
            img = cv.imread(fullfile(mexopencv.root(),'test','fruits.jpg'), 'Grayscale',true);

            [result,t] = cv.threshold(img, 'Otsu');
            validateattributes(result, {class(img)}, {'size',size(img)});
            validateattributes(t, {'numeric'}, {'scalar'});

            [result,t] = cv.threshold(img, 'Triangle');
            validateattributes(result, {class(img)}, {'size',size(img)});
            validateattributes(t, {'numeric'}, {'scalar'});
        end

        function test_compare_im2bw
            % requires Image Processing Toolbox
            if mexopencv.isOctave()
                img_lic = 'image';
                img_pkg = img_lic;
            else
                img_lic = 'image_toolbox';
                img_pkg = 'images';
            end
            if ~license('test', img_lic) || isempty(ver(img_pkg))
                disp('SKIP');
                return;
            end

            % compare against im2bw/graythresh
            img = imread(fullfile(mexopencv.root(),'test','left01.jpg'));
            [img1,t1] = cv.threshold(img, 'Otsu', 'MaxValue',255, 'Type','Binary');
            t2 = graythresh(img);
            img2 = im2bw(img, t2);
            if false
                assert(isequal(t1, round(t2*255)));
                assert(isequal(logical(img1), img2));
            end
        end

        function test_error_1
            try
                cv.threshold();
                throw('UnitTest:Fail');
            catch e
                assert(strcmp(e.identifier,'mexopencv:error'));
            end
        end
    end

end
