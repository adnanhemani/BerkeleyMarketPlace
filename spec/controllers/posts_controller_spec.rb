require 'rails_helper'
require 'rack/test'

RSpec.describe PostsController, type: :controller do
  
  # before do
  #   Posts.any_instance.stub(:save_attached_files).and_return(true) 
  #   @attachment = FactoryGirl.create :attachment
  # end


  describe "create action" do
    before :each do
      session[:user_id] = 1
    end
    #current_user = User.superusers[5]
    #puts(current_user)
    it "creates a new post in database" do
      post :create, post: { 
          :title => 'Sample Post', 
          :price => '233', 
          :description => 'Sample Post Description',
          :category => 'item',
          :subcategory => 'book',
          :image => Rack::Test::UploadedFile.new('spec/controllers/images/doge.png', 'image/png')
      }
      expect(assigns(:post)).to be_a(Post)
    end
    
    it "won't create the post if it doesn't have title or title exceed length" do
      post :create, post: { 
          :price => '233', 
          :description => 'Sample Post Description',
          :category => 'item',
          :subcategory => 'book',
          :image => Rack::Test::UploadedFile.new('spec/controllers/images/doge.png', 'image/png')
      }
      expect(flash[:notice]).to be_present
      post :create, post: { 
          :title => 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
          :price => '233', 
          :description => 'Sample Post Description',
          :category => 'item',
          :subcategory => 'book',
          :image => Rack::Test::UploadedFile.new('spec/controllers/images/doge.png', 'image/png')
      }
      expect(flash[:notice]).to be_present
      
    end
    
    it "won't create the post if it doesn't have price or price is not number" do
      post :create, post: { 
          :title => 'Sample Post', 
          :description => 'Sample Post Description',
          :category => 'item',
          :subcategory => 'book',
          :image => Rack::Test::UploadedFile.new('spec/controllers/images/doge.png', 'image/png')
      }
      expect(flash[:notice]).to be_present
      post :create, post: { 
          :title => 'Sample Post', 
          :price => 'hahaha',
          :description => 'Sample Post Description',
          :category => 'item',
          :subcategory => 'book',
          :image => Rack::Test::UploadedFile.new('spec/controllers/images/doge.png', 'image/png')
      }
      expect(flash[:notice]).to be_present
    end

    it "won't create the post if it doesn't have category or subcategory" do
      post :create, post: { 
          :title => 'Sample Post', 
          :price => '233', 
          :description => 'Sample Post Description',
          :image => Rack::Test::UploadedFile.new('spec/controllers/images/doge.png', 'image/png')
      }
      expect(flash[:notice]).to be_present
      post :create, post: { 
          :title => 'Sample Post', 
          :price => '233', 
          :description => 'Sample Post Description',
          :category => 'item',
          :image => Rack::Test::UploadedFile.new('spec/controllers/images/doge.png', 'image/png')
      }
      expect(flash[:notice]).to be_present
    end
    
    it "redirects to the show page" do

      post :create, post: { 
          :title => 'Sample Post', 
          :price => '233', 
          :description => 'Sample Post Description',
          :category => 'item',
          :subcategory => 'book',
          :image => Rack::Test::UploadedFile.new('spec/controllers/images/doge.png', 'image/png')
          #File.new(Rails.root.join('spec','factories','images','doge.png'))
      }
      @post = Post.last
      id = @post.id
      expect(response).to redirect_to("/posts/" + id.to_s)
    end
    
    # it "will change subcategory if we select certain category" do
    #   get :update_form_subcategory
    #   #expect(params[:category]).to eq ''
    # end
    
  end
  
  
  describe "can delete post as an admin" do
    before :each do
      superuser_email = User.superusers.sample
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
        "provider" => "google_oauth2",
        "uid" => "-999",
        "info" => {
          "name" => "Test User",
          "email" => superuser_email,
        },
        "credentials" => {
          "token" => "TEST_TOKEN",
          "refresh_token" => "TEST_REFRESH_TOKEN",
          "expires_at" => 32503680000, # 3000/1/1
          "expires" => true
        }
      })
    end
    
    it "can destroy certain post" do
      post :create, post: { 
          :title => 'Sample Post', 
          :price => '233', 
          :description => 'Sample Post Description',
          :category => 'item',
          :subcategory => 'book',
          :image => Rack::Test::UploadedFile.new('spec/controllers/images/doge.png', 'image/png')
      }
      @post = Post.last
      id = @post.id
      post :destroy, :id => id
      expect(response).to redirect_to("/")
    end
    
  end

  
  
  describe 'searching certain item' do
    before :each do
      session[:user_id] = 1
    end
    
    it 'calls the model method that performs search' do
      post :create, post: { 
          :title => 'iClicker1 for sale', 
          :price => '233', 
          :description => 'Sample Post Description',
          :category => 'item',
          :subcategory => 'electronics',
          :image => Rack::Test::UploadedFile.new('spec/controllers/images/doge.png', 'image/png')
      }
      expect(Post).to receive(:get_searched_posts).with('iclicker')
      post 'index', {:search_terms => 'iclicker'}
    end
    
    # it 'selects page for rendering' do
    #   allow(Post).to receive(:get_searched_posts)
    #   post :create, post: { 
    #       :title => 'iClicker1 for sale', 
    #       :price => '233', 
    #       :description => 'Sample Post Description',
    #       :category => 'item',
    #       :subcategory => 'electronics',
    #       :image => Rack::Test::UploadedFile.new('spec/controllers/images/doge.png', 'image/png')
    #   }
    #   post 'index', {:search_terms => 'iclicker'}
    #   # expect(response).to redirect_to(root_path)
    #   expect(response.body).to have_content("iClicker1 for sale")
    #   # expect(response).to 
    # end
  end

  
  
  
  
end
