# reference to a size 10 font - Helvetica will do for now
def font_10
    return UIFont.fontWithName('Helvetica', size: 10)
end

# fudge to get the real height of some 10pt text in a constrained width box
def real_height(text, width)
    s = text.sizeWithFont(font_10, constrainedToSize:[width,100000], lineBreakMode: 0)
    return s
end

# BLAH BLAH MADE UP WORDS BLAH MONKEYS BLAH TYPEWRITERS BLACH IPSUMA SDLAsk
def ipsum
    paras = [
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed est odio, suscipit eget imperdiet id; molestie ac ligula. Aenean suscipit odio vel justo bibendum a dictum orci bibendum. Phasellus euismod, libero id mollis volutpat, dolor quam vehicula enim, in euismod quam massa dictum urna.",
        "Donec leo nisi, pharetra eu rutrum eu, ultricies a enim. Maecenas ante ipsum, vestibulum aliquet lacinia viverra, rhoncus ac est. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. In hac habitasse platea dictumst.",
        "In hac habitasse platea dictumst. Aenean vehicula, purus vel interdum facilisis, urna risus dapibus justo, non facilisis leo quam pulvinar risus! Phasellus sapien est, egestas sed elementum in, lacinia id magna. Morbi sollicitudin dapibus quam, a vehicula nulla pretium et?",
        "Proin odio ipsum; rutrum a sodales ac, pretium quis ligula. Duis hendrerit suscipit tortor ac pellentesque! Curabitur et lorem ligula. Fusce ut diam at nisl condimentum accumsan.",
        "Sed sodales blandit est; a semper arcu accumsan ut. Cras mollis ante vitae quam rutrum a adipiscing eros blandit. Aliquam lacinia lectus ut lorem blandit a lacinia tortor rutrum. Vestibulum blandit ligula in orci interdum at commodo eros eleifend. Quisque eu tellus nec nulla congue semper ut vel mi.",
        "Praesent dapibus tellus vitae orci semper et eleifend lorem lacinia. Donec volutpat volutpat dolor, at porta mauris lacinia a. Nam sit amet elit turpis, nec feugiat lorem. In tincidunt est ut ipsum lacinia porttitor. Nunc dapibus consequat urna, eget tristique nibh congue eget.",
        "Suspendisse potenti. Aliquam et ante massa, sed elementum orci. In elit eros, condimentum sed auctor ut, placerat ut quam.",
        "Curabitur volutpat mattis libero quis dapibus. Aliquam vitae dui lacus. Sed quis quam augue! Nam velit dui, mollis in aliquet sit amet, egestas sit amet sem. Maecenas non enim erat. Donec lectus nisi, lobortis et euismod eu, iaculis vel justo.",
        "Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Sed fringilla sodales ultrices. Vestibulum cursus lacinia pretium? Aliquam ut lacus sit amet nibh vestibulum ullamcorper."
    ]

    # how many fake paragraphs do we want in our text box?
    wanted = 1.upto(paras.size).to_a.sort_by{rand}.first

    # put that many paragraphs in random order
    return paras.sort_by{rand}.first(wanted).join("\n")
end

class Table < UITableViewController
    attr_accessor :dsfpic, :words, :heights, :data

    def viewDidLoad
        super
        self.title = 'dsf'
        @table = self.tableView
        @table.dataSource = self
        @data = ('A'..'Z').to_a
        @words = []
        @heights = []

        @data.each do
            w = ipsum()
            @words.push w
            @heights.push real_height(w, 256).height
        end
        p @heights

        @dsfpic = UIImage.imageNamed('small-darrenf.jpg')
    end

    def tableView(tableView, heightForRowAtIndexPath: indexPath)
        cell_id = @data[indexPath.row]
        # 90.0 is our base cell size, 52.0 is our text box
        q = [90.0, 90.0-52.0+@heights[indexPath.row]].max
        return q
    end

    def tableView(tableView, cellForRowAtIndexPath: indexPath)
        cell_id = "CELL_ID"

        # return the UITableViewCell for the row
        @reuseIdentifier = cell_id

        cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
            x = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:@reuseIdentifier)
            # height of our text box - starts at 52.0, expands with text

            image = UIImageView.alloc.init
            image.frame = [[8,8], [44,44]]
            image.image = @dsf_pic
            image.setTag(8)
            x.contentView.addSubview(image)

            topright = UILabel.alloc.init
            topright.setFont(font_10)
            topright.setTag(9)
            topright.numberOfLines = 0
            x.contentView.addSubview(topright)

            botleft = UILabel.alloc.init
            botleft.setFont(font_10)
            botleft.setTag(10)
            x.contentView.addSubview(botleft)

            botright = UILabel.alloc.init
            botright.backgroundColor = UIColor.lightGrayColor
            botright.setFont(font_10)
            botright.setTag(11)
            x.contentView.addSubview(botright)

            x
        end

        q = [52, @heights[indexPath.row]].max
        cell.viewWithTag(9).frame = [[56,8], [256,q]]
        cell.viewWithTag(10).frame = [[8,q+12], [80,20]]
        cell.viewWithTag(11).frame = [[92,q+12], [220,20]]

        cell.viewWithTag(8).image = @dsfpic

        # botleft/10
        cell.viewWithTag(10).text = '[' + @data[indexPath.row] + '] Mingle Mangle'
        # topright/9
        cell.viewWithTag(9).text = @words[indexPath.row]
        # botright/11
        cell.viewWithTag(11).text = @heights[indexPath.row].to_s + ' /' + @data[indexPath.row] + '/ ' + @words[indexPath.row].length.to_s

        cell
    end

    def tableView(tableView, numberOfRowsInSection: section)
        # return the number of rows
        @data.count
    end
end
