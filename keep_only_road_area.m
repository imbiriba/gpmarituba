function ikeep = keep_only_road_area(x,y)

  % get road area
  paths = get_paths(50);

  a1 = paths{2}-complex(50,50);
  a1 = [a1 paths{2}(end)+complex(50,50)];
  a1 = [a1 paths{2}(end:-1:1)+complex(50,50)];
  a1 = [a1 paths{2}(1)-complex(50,50)];

  a2 = paths{4}-complex(0,50);
  a2 = [a2 paths{4}(end)+complex(0,50)];
  a2 = [a2 paths{4}(end:-1:1)+complex(0,50)];
  a2 = [a2 paths{4}(1)-complex(0,50)];

  % test locations
  for ii=1:numel(x)
    isin(ii) = isincountry(x(ii),y(ii),real(a1), imag(a1)) | isincountry(x(ii),y(ii),real(a2), imag(a2));
  end

  ikeep = find(isin);
end
