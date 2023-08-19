def decode_query_list_of_dict(string, *param_names):
    """
        5|4+3|2 
        TO 
        [
            {
                "param_name1" : 5,
                "param_name2" : 4,
            },
            {
                "param_name1" : 3,
                "param_name2" : 2
            }
        ]
    
    """
    array = [i.split('|') for i in string.split('+')]
    res = []

    for pair in array:
        dicto = {}
        for node, name in zip(pair, param_names):
            dicto[name] = node
        res.append(dicto)
    
    return res