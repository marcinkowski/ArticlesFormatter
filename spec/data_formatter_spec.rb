require "data_formatter"


RSpec.describe(DataFormatter) do
  let(:journals) { {"Title" => "Bartell-Collins", "ISSN" => "1167-8230"} }
  let(:articles) do
    [
        {"DOI" => "10.1234/altmetric111", "Title" => "Small Wooden Chair", "ISSN" => "11678230"},
        {"DOI" => "10.1234/altmetric222", "Title" => "Ergonomic Rubber Shirt", "ISSN" => "1167-8230"}
    ]
  end
  let(:authors) { '[{"name":"Akeem Toy","articles":["10.1234/altmetric111", "10.1234/altmetric222"]}]' }
  let(:result) {[["title","surname","firstname"],["title2","surname2","firstname2"]] }

  let(:csv_result) do
    "doi,title,author,journal,issn\n10.1234/altmetric111,Small Wooden Chair,Akeem Toy,Bartell-Collins,1167-8230\n10.1234/altmetric222,Ergonomic Rubber Shirt,Akeem Toy,Bartell-Collins,1167-8230\n"
  end

  let(:json_result) do
    '[{"doi":"10.1234/altmetric111","title":"Small Wooden Chair","author":"Akeem Toy","journal":"Bartell-Collins","issn":"1167-8230"},{"doi":"10.1234/altmetric222","title":"Ergonomic Rubber Shirt","author":"Akeem Toy","journal":"Bartell-Collins","issn":"1167-8230"}]'
  end

  before do
    expect(CSV).to receive(:foreach).with("journals_path", headers: true).and_yield(journals)
    expect(CSV).to receive(:foreach).with("articles_path", headers: true).and_yield(articles[0]).and_yield(articles[1])
    expect(File).to receive(:read).with("authors_path").and_return(authors)
    expect(File).to receive(:exists?).with("journals_path").and_return(true)
    expect(File).to receive(:exists?).with("articles_path").and_return(true)
    expect(File).to receive(:exists?).with("authors_path").and_return(true)
  end

  it "formats data to csv" do
    formatter = DataFormatter.new("journals_path", "articles_path", "authors_path")
    expect(formatter.to_csv).to eq(csv_result)
  end

  it "formats data to json" do
    formatter = DataFormatter.new("journals_path", "articles_path", "authors_path")
    expect(formatter.to_json).to eq(json_result)
  end
end