File.open(%q[C:\Users\shun_\VSCodeProjects\Ruby\Test\wf.rb], "r").each_line do |l|
    m = l.match /push(.+)/
    puts m[1] if m
end