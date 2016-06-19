require 'rails_helper'

RSpec.describe Arena, type: :model do
  it 'has a valid factory' do
    expect(FactoryGirl.build(:arena)).to be_valid
  end
  context "attribute 'name'" do
    it 'should be present' do
      arena = FactoryGirl.build(:arena, name: '')
      expect(arena).to_not be_valid
      expect(arena.errors).to have_key(:name)
    end
    it 'should be unique' do
      name = 'test_name'
      FactoryGirl.create(:arena, name: name)
      arena = FactoryGirl.build(:arena, name: name)
      expect(arena).to_not be_valid
      expect(arena.errors).to have_key(:name)
    end
    it 'should check length' do
      name = 'Z' * 256
      arena = FactoryGirl.build(:arena, name: name)
      expect(arena).to_not be_valid
      expect(arena.errors).to have_key(:name)
    end
  end
  context "attribute 'background'" do
    it 'could be empty' do
      attrs = {
          background_file_name:    nil,
          background_content_type: nil,
          background_file_size:    nil
      }
      arena = FactoryGirl.build(:arena, attrs)
      expect(arena).to be_valid
    end
    it 'should check MIME' do
      arena = FactoryGirl.build(:arena, background_content_type: 'image/tiff')
      expect(arena).to_not be_valid
      expect(arena.errors).to have_key(:background_content_type)
      expect(arena.errors).to have_key(:background)
    end
    it 'should check file name' do
      arena = FactoryGirl.build(:arena, background_file_name: 'test_name.tiff')
      expect(arena).to_not be_valid
      expect(arena.errors).to have_key(:background_file_name)
      expect(arena.errors).to have_key(:background)
    end
    it 'should check file size' do
      arena = FactoryGirl.build(:arena, background_file_size: 6.megabytes)
      expect(arena).to_not be_valid
      expect(arena.errors).to have_key(:background_file_size)
      expect(arena.errors).to have_key(:background)
    end
  end
  context "attribute 'foreground'" do
    it 'could be empty' do
      attrs = {
          foreground_file_name:    nil,
          foreground_content_type: nil,
          foreground_file_size:    nil
      }
      arena = FactoryGirl.build(:arena, attrs)
      expect(arena).to be_valid
    end
    it 'should check MIME' do
      arena = FactoryGirl.build(:arena, foreground_content_type: 'image/tiff')
      expect(arena).to_not be_valid
      expect(arena.errors).to have_key(:foreground_content_type)
      expect(arena.errors).to have_key(:foreground)
    end
    it 'should check file name' do
      arena = FactoryGirl.build(:arena, foreground_file_name: 'test_name.tiff')
      expect(arena).to_not be_valid
      expect(arena.errors).to have_key(:foreground_file_name)
      expect(arena.errors).to have_key(:foreground)
    end
    it 'should check file size' do
      arena = FactoryGirl.build(:arena, foreground_file_size: 2.megabytes)
      expect(arena).to_not be_valid
      expect(arena.errors).to have_key(:foreground_file_size)
      expect(arena.errors).to have_key(:foreground)
    end
  end
end
