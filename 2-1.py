import pandas as pd

def sort_dataset(dataset_df):
    return dataset_df.sort_values(by='year')

if __name__=='__main__':
    # Loading data
    data_df = pd.read_csv('2019_kbo_for_kaggle_v2.csv')
    
    # data preprocessing
    sorted_df = sort_dataset(data_df)

    # Print statistics of the top 10 players performing each year from 2015 to 2018
    for year in range(2015, 2019):
        top_players = sorted_df[sorted_df['year'] == year].nlargest(10, 'avg')
        print(f"Top 10 players in {year} based on batting average:")
        print(top_players[['batter_name', 'avg', 'year']])

    # Find the best players in each position in 2018
    best_players_by_position = sorted_df[sorted_df['year'] == 2018].groupby('cp').apply(lambda x: x.nlargest(1, 'war'))
    print("Best players in 2018 by position based on WAR:")
    print(best_players_by_position[['batter_name', 'cp', 'war']])

    # Analyze the statistics most relevant to players' salaries
    numerical_data_df = sorted_df.select_dtypes(include=[np.number])
    correlations = numerical_data_df.corr()['salary'].sort_values(ascending=False)
    print("Correlation of various statistics with salary:")
    print(correlations)
