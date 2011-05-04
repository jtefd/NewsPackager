package NewsPackager::DB::Schema::Result::Story;

use base 'DBIx::Class::Core';

__PACKAGE__->table('story');

__PACKAGE__->add_column(
	story_id => {
		data_type => 'integer',
		is_nullable => 0,
		is_auto_increment => 1
	}
);

__PACKAGE__->add_column(
	source_type => {
		data_type => 'integer',
		is_nullable => 0
	}
);

__PACKAGE__->add_column(
	title => {
		data_type => 'text',
		is_nullable => 0
	}
);

__PACKAGE__->add_column(
	summary => {
		data_type => 'text',
		is_nullable => 1
	}
);

__PACKAGE__->add_column(
	content => {
		data_type => 'text',
		is_nullable => 0
	}
);

__PACKAGE__->add_column(
	date => {
		data_type => 'datetime',
		is_nullable => 1
	}
);

__PACKAGE__->add_column(
	url => {
		data_type => 'varchar',
		is_nullable => 0
	}
);

__PACKAGE__->set_primary_key('story_id');

__PACKAGE__->add_unique_constraint(
	[ qw/url/ ]
);

__PACKAGE__->belongs_to('source_type', 'NewsPackager::DB::Schema::Result::SourceType');

1;