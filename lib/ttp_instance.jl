# TTP instance module

# Use RobinXml format!
module TTPInstance
    using DelimitedFiles
    using LightXML

    struct Instance
        n::UInt8
        d::Array{UInt16, 2}
        streak_limit::UInt8
        no_repeat::Bool
    end

    function read(file_name::String, streak_limit::Integer, no_repeat::Bool)
        xdoc = parse_file(file_name)
        # get the root element
        xroot = root(xdoc)  # an instance of XMLElement
        data = find_element(xroot,"Data")
        distance = find_element(data, "Distances")
        distances = collect(child_elements(distance))
        n = convert(Int64, sqrt(length(distances)))
        d = zeros(Int64, n, n)
        for c in distances
                # Julia uses 1-based numbering
                d[parse(Int64,attribute(c,"team1"))+1,parse(Int64,attribute(c,"team2"))+1] = parse(Int64,attribute(c, "dist"))
        end
        Instance(n, d, streak_limit, no_repeat)
    end
end


#module TTPInstance
#    using DelimitedFiles
#
#    struct Instance
#        n::Int
#        d::Array{UInt16, 2}
#        streak_limit::Int
#        no_repeat::Bool
#    end
#
#    function read(file_name::String, streak_limit::Integer, no_repeat::Bool)
#        d = readdlm(file_name, UInt16)
#        n = size(d)[1]
#        Instance(n, d, streak_limit, no_repeat)
#    end
#end
