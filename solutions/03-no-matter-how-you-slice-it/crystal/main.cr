
struct Claim
	property id, width_lower, width_upper, height_lower, height_upper
	def initialize(@id : UInt32, @width_lower : UInt32,  @width_upper : UInt32,
	                             @height_lower : UInt32, @height_upper : UInt32)
	end
end

claims = Set(Claim).new

File.read_lines("input.txt", chomp: true).each do |l|
	id          = l[l.index('#').not_nil! + 1..l.index('@').not_nil! - 2].to_u32
	margin_left = l[l.index('@').not_nil! + 2..l.index(',').not_nil! - 1].to_u32
	margin_top  = l[l.index(',').not_nil! + 1..l.index(':').not_nil! - 1].to_u32
	width       = l[l.index(':').not_nil! + 2..l.index('x').not_nil! - 1].to_u32
	height      = l[l.index('x').not_nil! + 1..-1].to_u32
	claims << Claim.new(id, margin_left, margin_left + width, margin_top, margin_top + height)
end

grid = Array.new(1000) { Array.new(1000) { 0 } }

claims.each do |claim|
	(claim.width_lower...claim.width_upper).each do |x|
		(claim.height_lower...claim.height_upper).each do |y|
			grid[x][y] += 1
		end
	end
end

overlap_count = 0
(0...1000).each do |x|
	(0...1000).each do |y|
		if grid[x][y] > 1
			overlap_count += 1
		end
	end
end

puts "Overlapping tiles: #{overlap_count}"

claims.each do |claim|
	is_valid = true
	(claim.width_lower...claim.width_upper).each do |x|
		(claim.height_lower...claim.height_upper).each do |y|
			if grid[x][y] > 1
				is_valid = false
			end
		end
	end
	if is_valid
		puts "Valid claim: #{claim.id}"
		break
	end
end
