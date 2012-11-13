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

        # We fake up 26 cells of data
        @data = ('A'..'Z').to_a
        @words = []
        @heights = []

        # Make 26 blocks of text with varying sizes
        @data.each do
            w = ipsum()
            @words.push w
            @heights.push real_height(w, 256).height
        end

        # We all love a beardy ginger
        @dsfpic = UIImage.imageNamed('small-darrenf.jpg')
    end

    def tableView(tableView, heightForRowAtIndexPath: indexPath)
        # 90.0 is our base cell size, 52.0 is our text box
        return [90.0, 90.0-52.0+@heights[indexPath.row]].max
    end

    def tableView(tableView, cellForRowAtIndexPath: indexPath)
        # Originally I was making this specific for each cell but that
        # seemed to go horribly wrong. Not sure I understand why.
        cell_id = "CELL_ID"

        # return the UITableViewCell for the row
        @reuseIdentifier = cell_id

        cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
            # create a blank new cell with our identifier
            x = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:@reuseIdentifier)

            # Top left is an image
            image = UIImageView.alloc.init
            image.frame = [[8,8], [44,44]]
            image.image = @dsf_pic
            image.setTag(8)
            x.contentView.addSubview(image)

            # Top right is a label pretending to be a UITextView
            # because we don't want any scrolling behaviour
            topright = UILabel.alloc.init
            topright.setFont(font_10)
            topright.setTag(9)
            # "as many lines as can fit in the space"
            topright.numberOfLines = 0
            x.contentView.addSubview(topright)

            # Bottom left is a small label for something like a timestamp
            botleft = UILabel.alloc.init
            botleft.setFont(font_10)
            botleft.setTag(10)
            x.contentView.addSubview(botleft)

            # Bottom right is the price of cheese
            botright = UILabel.alloc.init
            botright.backgroundColor = UIColor.lightGrayColor
            botright.setFont(font_10)
            botright.setTag(11)
            x.contentView.addSubview(botright)

            # "return" the new cell object
            x
        end

        # Resize and reposition according to the size of our text
        q = [52, @heights[indexPath.row]].max
        cell.viewWithTag(9).frame = [[56,8], [256,q]]
        cell.viewWithTag(10).frame = [[8,q+12], [80,20]]
        cell.viewWithTag(11).frame = [[92,q+12], [220,20]]

        # Since this can vary with each cell, we have to set it here
        cell.viewWithTag(8).image = @dsfpic

        # Ditto
        cell.viewWithTag(10).text = '[' + @data[indexPath.row] + '] Mingle Mangle'
        # Ditto
        cell.viewWithTag(9).text = @words[indexPath.row]

        # You get the idea
        cell.viewWithTag(11).text = @heights[indexPath.row].to_s + ' /' + @data[indexPath.row] + '/ ' + @words[indexPath.row].length.to_s

        # Return our cell for displaying
        cell
    end

    # We always have the same number of rows but let's pretend we don't
    def tableView(tableView, numberOfRowsInSection: section)
        @data.count
    end
end
