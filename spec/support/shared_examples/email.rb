def get_email_part (mail, type)
  mail.body.parts.find { |p| p.content_type.match type }.body.raw_source
end

shared_examples_for "multipart email" do
  it "generates a multipart message (plain text and html)" do
    expect(email.body.parts.length).to eq(2)
  end
end