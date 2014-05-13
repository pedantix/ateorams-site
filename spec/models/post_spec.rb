require 'spec_helper'

describe Post do
  it { should respond_to(:body) }
  it { should respond_to(:title) }
  it { should respond_to(:slug) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { should have_and_belong_to_many(:tags) }
  it { should have_and_belong_to_many(:admins) }



  describe "slug" do
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
        @dummy_item = Post.create(title: title, body: Faker::Lorem.paragraph )
      end

      after { @dummy_item.destroy }
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

  describe "building a post" do
    after(:each) do
      if example.exception
       @exception_text = "\n" if @exception_text.nil?
        @exception_text << "\nexception \n Tags: #{Tag.all.each {|n| puts n}}\n"
        @exception_text << "\nexception \n Posts: #{Post.all.each {|n| puts n}}\n"
      end
    end
    after(:all) do
      puts @exception_text unless @exception_text.nil?
    end

    context "without tags" do
      it "should be able to create a post" do 
        expect do
          Post.create!(title: "fake text", body: Faker::Lorem.paragraph )
        end.to change(Post, :count).by(1)
      end
    end

    context "with tags that do not exist" do
      it { should respond_to(:tags_text) }

      it "should be able to create a post and one tag" do 
        expect do
          Post.create!(title: "a random title", body: Faker::Lorem.paragraph, tags_text: "Javascript" )
        end.to change(Post, :count).by(1)
        expect(Tag.count).to eql 1
      end

      it "should be able to create two tags" do
        expect do
          Post.create!(title: "a random title", body: Faker::Lorem.paragraph, tags_text: "Javascript, Ruby" )
        end.to change(Post, :count).by(1)
        expect(Tag.count).to eql 2
        expect(Tag.find('ruby')).not_to be_nil
        expect(Tag.find('ruby').posts.count).to eql 1
      end
    end

    context "with tags that do exist" do
      let(:javascript_tag) { FactoryGirl.create(:tag, title: 'javascript') }
      let(:ruby_tag) { FactoryGirl.create(:tag, title: 'rubY') }
      before do
        javascript_tag; ruby_tag;
      end

      it "should be able to create a post and one tag" do 
        expect do
          Post.create!(title: "a title", body: Faker::Lorem.paragraph, tags_text: "Javascript" )
        end.to change(Post, :count).by(1)
        expect(javascript_tag.posts.count).to eql 1
        expect(ruby_tag.posts.count).to eql 0
      end

      it "should be able to create two tag relationships" do
        expect do
          Post.create!(title: "a title", body: Faker::Lorem.paragraph, tags_text: "Javascript, Ruby" )
        end.to change(Post, :count).by(1)
        expect(Tag.find('javascript').posts.count).to eql 1
        expect(Tag.find('ruby').posts.count).to eql 1
      end

      it "should be able to create a tag and two relationships" do
        expect do
          Post.create!(title: "a title", body: Faker::Lorem.paragraph, tags_text: "Javascript, Ruby, Erlang" )
        end.to change(Tag, :count).by(1)
        expect(Tag.find('javascript').posts.count).to eql 1
        expect(Tag.find('ruby').posts.count).to eql 1
        expect(Tag.find('erlang').posts.count).to eql 1
      end
    end

    context "should be able to reconstitue tags_text from db" do
      let(:tag_text) { "javascript, ruby, erlang"  }
      before do
        Post.create!(title: 'post title', body: Faker::Lorem.paragraph,  tags_text: tag_text)
      end

      it "reconstitues tags text" do
        expect(Post.first.tags_text).to eql tag_text

      end
    end
  end

  describe "#abstract_body" do
    before { FactoryGirl.create(:post, body: "#{'a ' * 500}") }
    it { should respond_to(:abstract_body) }
    it { expect(Post.first.abstract_body.length <= 300).to be_true }
  end

  describe "#author" do
    context "without an author should return ateorams" do
      let(:authorless) { FactoryGirl.create(:post) }
      it { expect(authorless.author).to eql 'ateorams'    }
    end

    context "with an author should return authors name" do
      let(:authored) { FactoryGirl.create(:post, :with_author)}
      it { expect(authored.author).to eql "Shaun Hubbard"    }

    end
  end

  describe "#has_owner?" do
    let(:md_post) { FactoryGirl.create(:post, body: "This is *markdown*, indeed.", tags_text: "javascript, ruby, MarkDown")}
    let(:admin) { FactoryGirl.create(:approved_admin) }
    let(:other_admin) { FactoryGirl.create(:approved_admin) }


    before(:each) do
      other_admin
      md_post.admins  = [admin]     
    end

    it "should be true for 'admin'" do
      expect(md_post.has_owner?(admin)).to be_true
    end


    it "should not be true for 'other admin'" do
      expect(md_post.has_owner?(other_admin)).not_to be_true

    end
  end
end
