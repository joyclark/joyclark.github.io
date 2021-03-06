require 'find'
require 'fileutils'

def image?(file)
	file.end_with?(".jpg") || file.end_with?(".jpeg") || file.end_with?(".png")
end

def convert_image(original, out, image_opts)
	new_name = original.sub '_raw_img', out
	new_dir = File.dirname(new_name)
	unless File.directory?(new_dir)
		puts "creating #{new_dir}"
		FileUtils.mkdir_p(new_dir)
	end

	if File.file?(new_name)
		puts "Skipping #{original}, #{new_name} already exists"
	else
		cmd = "convert #{original} #{image_opts} #{new_name}"
		puts "converting with #{image_opts} #{original}-->#{new_name}"
		system cmd
	end
end

def convert(file)
	if File.file?(file) && image?(file)
		convert_image(file, "img", "-resize 750 -strip -quality 86")
		convert_image(file, "img/thumbnail", "-resize 200 -strip -quality 86")
	end
end

Find.find('../_raw_img') { |e| convert e}
