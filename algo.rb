# given an array of binary arrays, count number of islands in it(group of ones connected either horizontally
# or vertically, not diagonally)

# Login I used:
# first get values at each place..
# get all ones and its adjacents in a hash..
# assign groups to all ones's. assign a group to an item(call it parent) if not already assigned.. 
# assign same group to its adjacent items.. 
# if parent does not have a group yet, but its adjacent item has, then assign the adjacent item's group 
# to parent..
# finally count number of groups formed

def get_all_items
    @items = {}
    @arr.each_with_index do |arr_outer, i|
      arr_outer.each_with_index do |arr_inner, j|
          @items["#{i}#{j}"] = arr_inner
      end
    end
end

def find_ones_and_its_adjacents
    @ones = {}
    @arr.each_with_index do |arr_outer, i|
      arr_outer.each_with_index do |arr_inner, j|
        if @items["#{i}#{j}"] == 1
            @ones["#{i}#{j}"] = [] if @ones["#{i}#{j}"] == nil
            @ones["#{i}#{j}"] << "#{i-1}#{j}" if i-1 >= 0
            @ones["#{i}#{j}"] << "#{i}#{j-1}" if j-1 >= 0
            @ones["#{i}#{j}"] << "#{i+1}#{j}" if i+1 < @arr.size
            @ones["#{i}#{j}"] << "#{i}#{j+1}" if j+1 < arr_outer.size
        end
      end
    end
end

def put_in_groups
    @groups = {}
    count = 1

    @ones.keys.each do |key|
        parent_group_before = @groups[key]
        @groups[key] = "group_#{count}" if @groups[key] == nil
        adjacents = @ones[key]

        adjacents.each do |adj|
            if @items[adj] == 1
                if @groups[adj].nil?
                    @groups[adj] = @groups[key]  
                else @groups[adj] != nil && parent_group_before == nil
                    # reverse - assign childs group to parent
                    @groups[key] = @groups[adj]
                end
            end
        end
        count += 1
    end

    return @groups
end

def has_invalid_values(arr)
    arr.blank? || (arr.map{|i| i.class} & [Integer, String, Hash]).any?
end

def count_islands(arr)
    return 'please provide valid input' if has_invalid_values(arr)

    @arr = arr
    get_all_items
    find_ones_and_its_adjacents
    put_in_groups

    count = @groups.values.uniq.count
    return "#{count} islands"
end

########## INPUT

examples = [
    [
        [1,0,0,1],
        [1,1,0,1],
        [1,0,1,1],
        [1,0,0,1],
    ],
    [
        [1,0,1,0,1],
        [0,1,0,1,0],
        [0,1,0,1,1]
    ],
    [
        [0, 1],
        [0, 0]
    ],
    [
        [1, 0, 1],
        [1, 0, 0],
        [0, 0, 0]
    ],
    [
        [1, 1, 1, 1, 0],
        [1, 1, 0, 1, 0],
        [1, 1, 0, 0, 0],
        [0, 0, 0, 0, 0]
    ],
    [        
        [1, 1, 0, 0, 0],
        [1, 1, 0, 0, 0],
        [0, 0, 1, 0, 0],
        [0, 0, 0, 1, 1]
    ],
    [
        [1, 1, 1, 0, 1],
        [1, 0, 1, 1, 1],
        [0, 1, 1, 0, 0],
        [0, 0, 0, 0, 1]
    ],
]


########## Calling count_islands method in loop

examples.each do |ex|
    puts "#{count_islands ex}"
end


########## Expected output

=begin
2 islands
5 islands
1 islands
2 islands
1 islands
3 islands
3 islands
=end
