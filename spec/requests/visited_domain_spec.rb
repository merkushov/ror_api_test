require 'rails_helper'

RSpec.describe 'Visited domains API', type: :request do
  # from = Time.now.to_i
  # to = Time.now.to_i + 10*60

  describe 'GET /visited_domains' do
    context 'without required params' do
      before { get '/visited_domains' }

      it "returns status code 422" do
        expect(response).to have_http_status(422)
      end
      it "returns a failure message" do
        expect(json['status']).to match(/Validation failed/i)
      end
      it "doesn't have 'domains'" do
        expect(json['domains']).to be_nil
      end
    end

    context 'for an interval without data' do
      before { get '/visited_domains', params: { from: 0, to: 1 } }

      it "returns status code 200" do
        expect(response).to have_http_status(200)
      end
      it "returns 'ok' in the status field" do
        expect(json['status']).to eq('ok')
      end
      it "returns 'domains' as an Array" do
        expect(json['domains']).to be_a_kind_of(Array)
      end
      it "returns empty 'domains'" do
        expect(json['domains']).to be_empty
      end
    end

    context 'for an interval with data' do
      before() do
        VisitedDomain.add_list(100, %w[ya.ru google.com])
        VisitedDomain.add_list(101, %w[funbox.ru])
        get '/visited_domains', params: { from: 99, to: 102 }
      end

      it "returns status code 200" do
        expect(response).to have_http_status(200)
      end
      it "returns 'ok' status" do
        expect(json['status']).to eq('ok')
      end
      it "returns 'domains' as an Array" do
        expect(json['domains']).to be_a_kind_of(Array)
      end
      it "returns 3 domains" do
        expect(json['domains']).to contain_exactly('ya.ru', 'google.com', 'funbox.ru')
      end
    end

    context 'extreme values are included in the requested interval' do
      before() do
        VisitedDomain.add_list(200, %w[ya.ru google.com])
        VisitedDomain.add_list(201, %w[funbox.ru])
        get '/visited_domains', params: { from: 200, to: 201 }
      end

      it "returns 3 domains" do
        expect(json['domains']).to contain_exactly('ya.ru', 'google.com', 'funbox.ru')
      end
    end
  end

  describe 'POST /visited_links' do
    let(:valid_attributes) { { links: %w[https://google.com/query=abc https://yandex.ru/news/1/show funbox.ru/about] } }

    context 'the request is valid' do
      before { post '/visited_links', params: valid_attributes }

      it "returns status code 200" do
        expect(response).to have_http_status(200)
      end
      it "returns 'ok' in the status field" do
        expect(json).to include("status" => "ok")
      end
    end

    context 'the request is invalid (''links'' field is not specified)' do
      before { post '/visited_links', params: {} }

      it "returns status code 422" do
        expect(response).to have_http_status(422)
      end
      it "returns a failure message" do
        expect(json['status']).to match(/Validation failed/i)
      end
    end

    context 'the request is invalid (''links'' field has a wrong type)' do
      before { post '/visited_links', params: {} }

      it "returns status code 422" do
        expect(response).to have_http_status(422)
      end
      it "returns a failure message" do
        expect(json['status']).to match(/Validation failed/i)
      end
    end
  end
end