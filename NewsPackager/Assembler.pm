package NewsPackager::Assembler;

use Date::Simple qw/today/;
use Digest::MD5 qw/md5_hex/;
use Encode qw/decode/;
use File::Spec::Functions;
use FindBin;
use HTML::Element;
use HTML::FromText;
use HTML::Template;
use NewsPackager::DB;
use POSIX qw/strftime/;

use constant ENCODING => 'UTF-8';

sub new() {
	my ($class) = @_;
	
	return bless({}, $class);
}

sub source {
	my $schema = NewsPackager::DB::schema;
	
	my $body = HTML::Element->new('body');

	my $menu = HTML::Element->new('ul');
	
	my $rs = $schema->resultset('NewsPackager::DB::Schema::Result::Story')->search_rs(
		{},
		{
			'order_by' => { '-asc' => 'date'},
			'where' => { 'date' => { '>=' => strftime('%Y-%m-%d 22:00:00', gmtime(time - (60*60*24))) } }
		}
	);
	
	while (my $row = $rs->next) {
		my $id = md5_hex($row->get_column('url'));
		
		my $title = decode(ENCODING, $row->get_column('title'));
		my $summary = decode(ENCODING, $row->get_column('summary'));
		my $content = decode(ENCODING, $row->get_column('content'));

		my $link = HTML::Element->new('li');
		my $alink = HTML::Element->new('a', href => '#' . $id);
		$alink->push_content($title);

		$link->push_content($alink);

		$menu->push_content($link);

		my $story_div = HTML::Element->new('div', class => 'story');

		my $header = HTML::Element->new('h1');

		my $anchor = HTML::Element->new('a', name => $id);
		$anchor->push_content($title);

		$header->push_content($anchor);

		my $summary_div = HTML::Element->new('div', class => 'summary');
		$summary_div->push_content($summary);
		
		
		my $content_div = HTML::Element->new('~literal', 'text', text2html($content, paras => 1));
		
		$story_div->push_content($header);
		$story_div->push_content($summary_div);
		$story_div->push_content($content_div);
		
		$body->push_content($story_div);
	}

	$body->unshift_content($menu);

	my $template = HTML::Template->new(filename => catfile($FindBin::Bin, 'newspackager.tmpl'));
	$template->param(BODY => $body->as_HTML);
	$template->param(TITLE => strftime('NewsPkg %Y/%m/%d', gmtime));
	
	return $template->output;
}

1;
