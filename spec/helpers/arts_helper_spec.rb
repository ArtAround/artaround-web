require 'spec_helper'

describe ArtsHelper do
  describe "#pretty_print_tags" do
    it "returns tags that are not blank" do
      submission = Submission.new tag: [nil, '', 'modern']
      expect(helper.pretty_print_tags(submission)).to eq(['modern'])
    end

    it "returns empty array when tags is nil" do
      submission = Submission.new tag: nil
      expect(helper.pretty_print_tags(submission)).to eq([])
    end
  end

  describe "#pretty_print_categories" do
    it "returns categories that are not blank" do
      submission = Submission.new category: [nil, '', 'wall art']
      expect(helper.pretty_print_categories(submission)).to eq(['wall art'])
    end

    it "returns an array of categories if the category is a string" do
      submission = Submission.new category: 'wall art'
      expect(helper.pretty_print_category(submission)).to eq(['wall art'])
    end

    it "returns empty array when tags is nil" do
      submission = Submission.new tag: nil
      expect(helper.pretty_print_categories(submission)).to eq([])
    end
  end

  describe "#pretty_print_artist" do
    it "returns tags that are not blank" do
      submission = Submission.new artist: 'Pablo Picasso'
      expect(helper.pretty_print_artist(submission)).to eq('Pablo Picasso')
    end

    it "returns empty array when tags is nil" do
      submission = Submission.new artist: nil
      expect(helper.pretty_print_artist(submission)).to eq('')
    end
  end

end
