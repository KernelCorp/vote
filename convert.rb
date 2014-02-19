models_path = 'spec/models'
contro_path = 'spec/controllers'

Dir.glob(models_path + "/*").sort.each do |f|
  filename = File.basename(f, File.extname(f))
  File.rename(f, models_path + "/" + filename.gsub(/_test/, '_spec') + File.extname(f))
end

Dir.glob(contro_path + "/*").sort.each do |f|
  filename = File.basename(f, File.extname(f))
  File.rename(f, contro_path + "/" + filename.gsub(/_test/, '_spec') + File.extname(f))
end

