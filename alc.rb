#!/usr/bin/ruby1.8
require "nokogiri"
require "uri"
require "optparse"

begin

$cond = "[false]"
OptionParser.new do |opt|
  opt.on("-n N", Integer){|n| $cond = "[position()>#{n}]" }
  opt.parse!(ARGV)
end

exit if ARGV.empty?

word = ARGV.join(" ")
url = "http://eow.alc.co.jp/#{URI.escape(word)}/UTF-8"
list = Nokogiri::HTML(`curl --silent "#{url}"`).xpath("//div[@id='resultsList']")
list.xpath("//ul/li#$cond").map{|n|n.remove}
list.xpath("//span[@class='midashi']").map{|n|n.inner_html = "--- " + n.inner_html }
list.xpath("//span[@class!='midashi' and @class!='wordclass']").map{|n|n.inner_html += "\n" }
list.xpath("//li").map{|n|n.inner_html += "\n" }
list.xpath("//span[@class='kana']").map{|n|n.remove}
list.xpath("//br").map{|n|n.before("this_is_dummy\n")}
puts list.text.map{|l|l.strip}.select{|l|!l.empty?}.map{|l|l.gsub(/this_is_dummy/,"")}

rescue
  exit
end
