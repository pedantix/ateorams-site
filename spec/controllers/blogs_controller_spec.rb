require 'spec_helper'

describe BlogsController do
  it { expect(subject).to route(:get, 'blogs').to( controller: :blogs, action: :index)}
end
