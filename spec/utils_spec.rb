require 'utils'

describe Utils do

  describe ".convert_links_to_domains" do
    context "list of 3 regular links with different domains" do
      list = %w[
        http://ya.ru?q=123
        http://google.com
        http://mail.ru/mail?login=user1&passord=12345
      ]

      it "the result is an Array" do
        expect(Utils.convert_links_to_domains(list)).to be_a_kind_of(Array)
      end
      it "returns a list of 3 different domains" do
        expect(Utils.convert_links_to_domains(list)).to contain_exactly('ya.ru', 'google.com', 'mail.ru' )
      end
    end

    context "wrong argument type" do
      it "raise an exception" do
        expect { Utils.convert_links_to_domains("http://ya.ru/q=123") }.to raise_error(ArgumentError)
      end
    end

    context "there is a plain domain in the list" do
      list = %w[
        http://ya.ru?q=123
        funbox.ru
      ]
      it "converted successfully" do
        expect(Utils.convert_links_to_domains(list)).to contain_exactly('ya.ru', 'funbox.ru')
      end
    end

    context "There is a link in a subdomain" do
      list = %w[
        https://google.com/search?q=abc
        https://news.co.uk/news/abc-def
        http://ya.ru
      ]
      it "converted successfully" do
        expect(Utils.convert_links_to_domains(list)).to contain_exactly('google.com', 'news.co.uk', 'ya.ru')
      end
    end
  end
end