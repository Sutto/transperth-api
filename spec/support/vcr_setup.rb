VCR.config do |c|
  c.cassette_library_dir = Rails.root.join('spec', 'fixtures')
  c.stub_with :webmock
end

module VCRCassetteExtensions

  def self.extended(parent)
    class << parent
      alias_method_chain :use_vcr_cassette, :suffixing
    end
  end

  # Extends use_vcr_cassette to include support for per-test suffixed scenarios.
  def use_vcr_cassette_with_suffixing(*args)
    use_vcr_cassette_without_suffixing(*args)
    before :each do
      if example.metadata[:suffix_cassette]
        normalized_name = Jammbox::NameNormalizer.normalize(example.description)
        existing = VCR.eject_cassette
        new_name = File.join(existing.name, normalized_name)
        VCR.insert_cassette new_name, {:record => :all}.merge(example.metadata[:vcr] || {})
      end
    end
  end

end