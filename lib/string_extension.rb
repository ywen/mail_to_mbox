module StringExtension
    def to_mbox_format
        lines = self.split("\n")
        from_line = lines.find {|line| line =~ /From/}
        return self unless from_line
        lines.delete(from_line)
        lines.insert(0, from_line.sub("From:", "From"))
        lines.join("\n") + "\n"
    end
end

class String; include StringExtension; end