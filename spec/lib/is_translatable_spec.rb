require 'spec_helper'

# NOTE: trying to switch closer to this style (mostly for the nicer errors)
# http://eggsonbread.com/2010/03/28/my-rspec-best-practices-and-tips/
describe IsTranslatable do
	before :each do
		titles = {
			:en => 'Translations now easier',
			:es => 'Traducciones ahora facil',
			:fr => 'Traductions maintenant plus facile'
		}
	end
	it 'should have tests'

	context 'article translations' do
		before {@article = Article.new(:title => 'Translations now easier', :body => 'is_translatable plugin makes translating easier...')}
		subject {@article}
		
		specify {subject.save.should be_true}
		it {should be_valid}

		context 'with spanish locale' do
			before {I18n.locale = :es}

			context 'with translated title' do
				before {@article.translation(:title, @titles[:es])}
				it {should be_valid}
				it "should check that it's actually translated"
			end

			context 'with translated title and locale override' do
				before {@article.translation(:title, @titles[:fr], :fr)}
				it {should be_valid}
				it "should check that it's actually translated to french"
			end

		end
	end
end
