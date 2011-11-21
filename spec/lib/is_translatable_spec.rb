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

          context 'and removed' do
            before :each do
              @loaded_article.remove_translation(:title)
              @loaded_article.save!
            end

            it {subject.get_translation(:title).should be_nil}
          end
        end
      end

      it 'should not translate if not translatable' do
        lambda {@article.set_translation(:non_translatable, 'foo')}.should raise_error(ArgumentError)
      end

      context 'with translated title and locale override' do
        before {@article.set_translation(:title, @titles[:fr], :fr)}
        it {should be_valid}

        it 'should allow specifying fallback behavior?'
        it {subject.get_translation(:title).should == nil}
        it {subject.get_translation(:title, :fr).should == @titles[:fr]}
      end

    end
  end

  context 'multiple translations' do
    before :each do
      # Creating these in a couple of different ways to excersize the code a little better.
      # Also putting in overlapping ids to make sure we're loading for the right table.
      @article1 = Article.new(:title => 'Article Title', :body => 'Article Body')
      @article1.id = 1
      @article1.set_translation(:title, 'es A1T', :es)
      @article1.set_translation(:title, 'pt-BR A1T', :'pt-BR')
      @article1.set_translation(:body, 'pt-BR A1B', :'pt-BR')
      @article1.save!

      article2 = Article.new(:title => 'Article2 Title', :body => 'Article2 Body')
      article2.id = 2
      article2.set_translation(:title, 'es A2T', :es)
      article2.set_translation(:title, 'pt-BR A2T', :'pt-BR')
      article2.set_translation(:body, 'pt-BR A2B', :'pt-BR')
      article2.save!
      @article2 = Article.find(article2.id)

      @note1 = Note.create!(:body => 'Note Body')
      @note1.set_translation(:body, 'pt-BR N1B', :'pt-BR')
      @note1.set_translation(:body, 'es N1B', :'es')
      @note1.save!

      @note2 = Note.new(:body => 'Note2 Body')
      @note2.set_translation(:body, 'pt-BR N2B', :'pt-BR')
      @note2.set_translation(:body, 'es N2B', :'es')
      @note2.save!
    end

    context 'article1' do
      subject {@article1}
      
      it {should be_valid}
      it {subject.get_translation(:title, :es).should == 'es A1T'}
      it {subject.get_translation(:title, :'pt-BR').should == 'pt-BR A1T'}
      it {subject.get_translation(:body, :'pt-BR').should == 'pt-BR A1B'}
      it {subject.get_translation(:body, :es).should be_nil}
    end

    context 'article2' do
      subject {@article2}
      
      it {should be_valid}
      it {subject.get_translation(:title, :es).should == 'es A2T'}
      it {subject.get_translation(:title, :'pt-BR').should == 'pt-BR A2T'}
      it {subject.get_translation(:body, :'pt-BR').should == 'pt-BR A2B'}
      it {subject.get_translation(:body, :es).should be_nil}
    end

    context 'note1' do
      subject {@note1}
      
      it {should be_valid}
      it {subject.get_translation(:body, :'pt-BR').should == 'pt-BR N1B'}
      it {subject.get_translation(:body, :es).should == 'es N1B'}
    end

    context 'note2' do
      subject {@note2}
      
      it {should be_valid}
      it {subject.get_translation(:body, :'pt-BR').should == 'pt-BR N2B'}
      it {subject.get_translation(:body, :es).should == 'es N2B'}
    end

    context 'article1 body translations deleted' do
      before :each do
        @article1.remove_translation(:body, :es)
        @article1.remove_translation(:body, :'pt-BR')
        @article1.save!
      end

      context 'article1 reloaded' do
        before { @article1_loaded = Article.find(@article1.id) }
        subject { @article1_loaded }

        it {subject.get_translation(:title, :es).should == 'es A1T'}
        it {subject.get_translation(:title, :'pt-BR').should == 'pt-BR A1T'}
        it {subject.get_translation(:body, :es).should be_nil}
        it {subject.get_translation(:body, :'pt-BR').should be_nil}
      end

      context 'article2' do
        subject {@article2}
        it {subject.get_translation(:body, :'pt-BR').should == 'pt-BR A2B'}
        it {subject.get_translation(:body, :es).should be_nil}
      end

      context 'note1' do
        subject {@note1}
        it {subject.get_translation(:body, :'pt-BR').should == 'pt-BR N1B'}
        it {subject.get_translation(:body, :es).should == 'es N1B'}
      end

      context 'note2' do
        subject {@note2}
        it {subject.get_translation(:body, :'pt-BR').should == 'pt-BR N2B'}
        it {subject.get_translation(:body, :es).should == 'es N2B'}
      end
    end
  end
end
