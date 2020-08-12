def wf_str_to_array(str)
    ans=[]

    str.gsub(/wf/i, "").split(",").each do |splitted|
        m = /(\d+)-(\d+)/.match(splitted)
        if m
            starti, endi = m[1].to_i, m[2].to_i
            starti.step(endi, endi<=>starti) {|i| ans.push(i)}
        else
            ans.push(splitted.to_i)
        end 
    end
    return ans
end

p wf_str_to_array("wf3-1,5,7-25")