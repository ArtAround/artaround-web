require_relative '../../app/models/params_cleaner'

describe ParamsCleaner do
  let(:params) {
    {
      title: "Digital%20Fountain",
      address: { street: "Michigan%20Ave.", number: "24", zipcode: "60601" },
      categories: ["Digital%20Arts", "Modern"]
    }
  }

  describe ".clean" do
    it "removes unescaped characters" do
      ParamsCleaner.clean(params)
      expect(params[:title]).to eq("Digital Fountain")
    end

    it "removes unescaped characters on nested hashes" do
      ParamsCleaner.clean(params)
      expect(params[:address][:street]).to eq("Michigan Ave.")
    end

    it "removes unescaped characters on nested arrays" do
      ParamsCleaner.clean(params)
      expect(params[:categories][0]).to eq("Digital Arts")
    end
  end
end
