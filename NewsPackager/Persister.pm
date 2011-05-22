package NewsPackager::Persister;

use strict;
use warnings;

use NewsPackager::DB;

sub new() {
	my ($class) = @_;
	
	return bless({}, ref $class || $class);
}

sub persist($) {
	my ($self, $feed) = @_;
	
	my $schema = NewsPackager::DB::schema();
	
	my $source_type = $schema->resultset('NewsPackager::DB::Schema::Result::SourceType')->find_or_create(
		{
			name => $feed->type
		}
	);
				
	$schema->resultset('NewsPackager::DB::Schema::Result::Story')->update_or_create(
		{
			url => $feed->url,
			title => $feed->title,
			summary => $feed->summary,
			date => $feed->date,
			content => $feed->content,
			source_type => $source_type
		}
	);					
}

1;