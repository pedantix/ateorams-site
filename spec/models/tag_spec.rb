require 'spec_helper'

describe Tag do
  it { should have_and_belong_to_many(:posts) }


  describe "slug" do
    it { should validate_presence_of(:title) }

    it { should have_db_index(:slug).unique(true) }

    it { should validate_presence_of(:slug) }

    it "should be camel case and hyphonated friendly" do
      should allow_value("1-or-Two-Hyphonated").for(:slug) 
      should allow_value("camelCaseRails").for(:slug) 
      should_not allow_value("butOnlyalphanumhyph?").for(:slug)
      should_not allow_value("an_underscored_value").for(:slug)
    end

    describe "slug is derived from name" do
      def make_test_item(title)
        @dummy_item = Tag.create!(title: title)
      end

      [
        ['simple case', 'this is simple', 'this-is-simple'],
        ['less simple case', 'this  is less simple', 'this-is-less-simple'],
        ['special char case', '?oh noes +3-  special chars!', 'oh-noes-3-special-chars']
      ].each do |args|
        specify "handles #{args[0]}converts the name '#{args[1]}' to '#{args[2]}'"do
          new_item = make_test_item(args[1])
          expect(new_item.slug).to eql args[2]
        end
      end
    end
  end
end
