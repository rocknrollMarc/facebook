class Mention
  include DataMapper::Resource

  property :id , Serial

  belongs_to :user
  belongs_to :status

  URL_REGEXP = Regexp.new('\b ((https?|telnet|gopher|file|wais|ftp) :
   [\w/#~:.?+=&%@!\-] +?) (?=[.:?\-] * (?: [^\w/#~:.?+=&%@!\-]| $ ))',
   Regexp::EXTENDED)
   AT_REGEXP = Regexp.new('@[\w.@_-]+', Regexp::EXTENDED)
end
