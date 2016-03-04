require "csv"
require "json"

class DataFormatter
  def initialize(journals_path, articles_path, authors_path)
    @journals_path = journals_path
    @articles_path = articles_path
    @authors_path = authors_path

    validate
  end

  def to_hashes
    journals = {}
    result = []
    authors = JSON.parse(File.read(@authors_path))

    CSV.foreach(@journals_path, headers: true) do |row|
      journals[fix_issn(row["ISSN"])] = row["Title"]
    end

    CSV.foreach(@articles_path, headers: true) do |row|
      issn = fix_issn(row["ISSN"])
      journal = journals[issn]
      result << {
          doi: row["DOI"],
          title: row["Title"],
          author: authors.detect { |author| author["articles"].include?(row["DOI"]) }["name"],
          journal: journal,
          issn: issn
      }
    end
    result
  end

  def to_csv
    hashes = to_hashes
    column_names = hashes.first.keys
    return CSV.generate do |csv|
      csv << column_names
      hashes.each do |x|
        csv << x.values
      end
    end
  end

  def to_json
    to_hashes.to_json
  end

  private

  def validate
    unless File.exists?(@journals_path) && File.exists?(@articles_path) && File.exists?(@authors_path)
      raise RuntimeError.new("Incorrect path to data file.");
    end
  end

  def fix_issn(issn)
    unless (issn =~ /\d{4}-\d{4}/)
      issn = "#{issn.slice(0, 4)}-#{issn.slice(4, 4)}"
    end

    issn
  end
end
