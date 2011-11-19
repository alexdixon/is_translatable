require 'spec_helper'

# NOTE: trying to switch closer to this style (mostly for the nicer errors)
# http://eggsonbread.com/2010/03/28/my-rspec-best-practices-and-tips/
describe IsTranslatable do
  before :each do
    @titles = {
      :en => 'Translations now easier',
      :es => 'Traducciones ahora facil',
      :fr => 'Traductions maintenant plus facile'
    }
  end

  it 'should test default locale (just using the actual field)'
  it 'should only allow translations for translatable fields'
  it 'should delete translations'
  it 'should be even more awesome'

  context 'article translations' do
    before {@article = Article.new(:title => 'Translations now easier', :body => 'is_translatable plugin makes translating easier...')}
    subject {@article}

    specify {subject.save.should be_true}
    it {should be_valid}

    context 'with spanish locale' do
      before {I18n.locale = :es}

      context 'with translated title' do
        before {@article.set_translation(:title, @titles[:es])}
        it {should be_valid}

        it {subject.get_translation(:title).should == @titles[:es]}

        context 'set twice' do
          before {@article.set_translation(:title, 'spanish override')}

          it {subject.translations.length.should == 1}
          it {subject.get_translation(:title).should == 'spanish override'}
        end

        context 'loaded from db' do
          before :each do
            @article.save!
            @loaded_article = Article.find(@article.id)
          end
          subject{@loaded_article}

          it {should be_valid}

          it {subject.get_translation(:title).should == @titles[:es]}
        end
      end

      context 'with translated title and locale override' do
        before {@article.set_translation(:title, @titles[:fr], :fr)}
        it {should be_valid}

        it "should check that it's actually translated to french"
      end

    end
  end
end
